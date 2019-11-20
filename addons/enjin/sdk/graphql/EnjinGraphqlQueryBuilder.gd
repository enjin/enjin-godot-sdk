extends Reference

class GQLTemplate:
    var _path: String
    var _arguments: Dictionary = {}
    var _body: String = ""
    
    func _init(var path: String):
        _path = path
    
    func GetPath():
        return _path
    
    func AddArgument(var arg_name: String, var arg_type = null, var default_value = null):
        if not _arguments.has(arg_name):
            _arguments[arg_name] = {"type": arg_type, "default_value": default_value}
        
    func GetArguments() -> Dictionary:
        return _arguments
    
    func ListArguments(var separator: String = "\n") -> String:
        var ret = ""
        for arg_name in GetArguments().keys():
            var arg = GetArguments().get(arg_name)
            var default_value_ending = ""
            var argument_type = ""
            if arg.type:
                argument_type = ": " + arg.type
            if arg.default_value:
                default_value_ending = " = " + arg.default_value
            ret += "$" + arg_name + argument_type + default_value_ending + separator
        return ret.rstrip(separator)
    
    func MergeWith(var other: GQLTemplate):
        var other_arguments = other.GetArguments()
        for key in other_arguments.keys():
            if not _arguments.has(key):
                _arguments[key] = other_arguments[key]
        
        SetBody(GetBody() + other.GetBody())
    
    func SetBody(var body: String):
        _body = body
    
    func GetBody() -> String:
        return _body


class GQLBuilder:
    extends Reference
    
    const tamplates_path = "res://addons/enjin/sdk/graphql/templates/"
    
    var FragmentDB: Dictionary = {}
    var QueryDB: Dictionary = {}
    var MutationDB: Dictionary = {}
    
    func RegisterQL(var gql_file_path: String):
        var gql_file = File.new()
        gql_file.open(gql_file_path, File.READ)
        
        while not gql_file.eof_reached():
            var line = gql_file.get_line()
            
            line = line.strip_edges()
            
            var is_query = line.begins_with("query")
            var is_mutation = line.begins_with("mutation")
            var is_fragment = line.begins_with("fragment")
            var is_argument = line.begins_with("$")
            var is_fragment_reference = line.begins_with("...")
            
            
            if is_query or is_mutation or is_fragment:
                #Populate DB
                var gql = gql_file.get_as_text()
                var key = gql_file_path.get_file().trim_suffix("."+gql_file_path.get_extension())
                if is_query and not QueryDB.has(key):
                    QueryDB[key] = GQLTemplate.new(gql_file_path)
                if is_mutation and not MutationDB.has(key):
                    MutationDB[key] = GQLTemplate.new(gql_file_path)
                if is_fragment and not FragmentDB.has(key):
                    FragmentDB[key] = GQLTemplate.new(gql_file_path)
                break
            
    func Scan(var path: Array, var curr_folder: String):
        #print("====== " + curr_folder + " =======")
        var directory = Directory.new()
        directory.change_dir(curr_folder)
        
        if(!directory.list_dir_begin()):
            while true:
                var file = directory.get_next()
                if file == "":
                    break
                if directory.current_is_dir():
                    if file != "." and file != "..":
                        path.append(file)
                        Scan(path, curr_folder + file + "/")
                else:
                    RegisterQL(curr_folder + file)
    
    func _init():
        pass
    
    func ScanAll():
        Scan([], tamplates_path)
    
    func GetQueryDB() -> Dictionary:
        return QueryDB

    func GetMutationDB() -> Dictionary:
        return MutationDB

    func GetFragmentDB() -> Dictionary:
        return FragmentDB
    
    func UseFolder(var path: String):
        var folders = path.get_base_dir().trim_prefix(self.tamplates_path)
        
        #Re-scan (probably not necessary)
        var node_path = NodePath(folders)
        var key_array = []
        for folder_id in range(0, node_path.get_name_count()):
            var folder = node_path.get_name(folder_id)
            key_array.append(folder)
        
        Scan(key_array, path)
    
    func ReadQL(var gql_file_path: String, var in_gql_template: GQLTemplate) -> GQLTemplate:
        var filename = gql_file_path.get_file().trim_suffix("."+gql_file_path.get_extension())
        var ret = ""
        
        var gql_file = File.new()
        gql_file.open(gql_file_path, File.READ)
        
        var includes = []
        var arguments = []

        var key = gql_file_path.get_file().trim_suffix("."+gql_file_path.get_extension())
        var gql_template: GQLTemplate = null
        if in_gql_template:
            gql_template = in_gql_template
        
        while not gql_file.eof_reached():
            var line = gql_file.get_line()
            
            var tmp_line = line.strip_edges()
            
            var is_query = tmp_line.begins_with("query")
            var is_mutation = tmp_line.begins_with("mutation")
            var is_fragment = tmp_line.begins_with("fragment")
            var is_argument = tmp_line.begins_with("$")
            var is_fragment_reference = tmp_line.begins_with("...")
            
            if is_query and QueryDB.has(key):
                gql_template = QueryDB[key]
            if is_mutation and MutationDB.has(key):
                gql_template = MutationDB[key]
            if is_fragment and FragmentDB.has(key):
                gql_template = FragmentDB[key]
            
            if is_query:
                line = line.replace("query", "query " + filename + "(\n" + "%s" + "\n)")
            if is_mutation:
                line = line.replace("mutation", "mutation " + filename + "(\n" + "%s" + "\n)")
            if is_fragment:
                pass
            if is_argument:
                var eq_pos = tmp_line.find_last("=")
                var col_pos = tmp_line.find_last(":")
                
                var default_value = null
                var type = null
                
                if eq_pos != -1:
                    default_value = tmp_line.substr(eq_pos+1).strip_edges()
                if col_pos != -1:
                    if eq_pos != -1:
                        type = tmp_line.substr(col_pos+1, eq_pos-col_pos-1).strip_edges()
                    else:
                        type = tmp_line.substr(col_pos+1).strip_edges()
                
                var argument_name = tmp_line.substr(0, col_pos).trim_prefix("$")
                
                gql_template.AddArgument(argument_name, type, default_value)

            if is_fragment_reference:
                #Find fragment in DB
                var fragment_name = tmp_line.trim_prefix("...")
                if FragmentDB.has(fragment_name):
                    #Found fragment, include
                    includes.append(fragment_name)
            
            if not is_argument:
                ret += line + "\n"

        if gql_template:
            gql_template.SetBody(ret)

        for include in includes:
            var tmp_template = ReadQL(FragmentDB[include].GetPath(), gql_template)
            if gql_template:
                gql_template.MergeWith(tmp_template)

        return gql_template

static func FindTemplate(var query_name) -> GQLTemplate:
    var gql_builder = GQLBuilder.new()
    
    gql_builder.UseFolder(GQLBuilder.tamplates_path)
    var QueryDB = gql_builder.GetQueryDB()
    var MutationDB = gql_builder.GetMutationDB()
    
    var query_template = null
    
    if QueryDB.has(query_name):
        query_template = gql_builder.ReadQL(QueryDB[query_name].GetPath(), null)
        return query_template
    if MutationDB.has(query_name):
        query_template = gql_builder.ReadQL(MutationDB[query_name].GetPath(), null)
        return query_template
    
    return query_template

static func BuildQuery(var query_name) -> String:
    var query_template = FindTemplate(query_name)
    var query = query_template.GetBody() % query_template.ListArguments(",\n")
    return query
