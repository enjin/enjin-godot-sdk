extends Reference

class GQLTemplate:
    var _path: String
    var _arguments: Dictionary = {}
    var _body: String = ""
    var _is_cached: bool = false
    
    func _init(var path: String):
        _path = path
    
    func get_path():
        return _path
    
    func add_argument(var arg_name: String, var arg_type = null, var default_value = null):
        if not _arguments.has(arg_name):
            _arguments[arg_name] = {"type": arg_type, "default_value": default_value}
    
    func get_arguments() -> Dictionary:
        return _arguments
    
    func list_arguments(var separator: String = "\n") -> String:
        var ret = ""
        for arg_name in get_arguments().keys():
            var arg = get_arguments().get(arg_name)
            var default_value_ending = ""
            var argument_type = ""
            if arg.type:
                argument_type = ": " + arg.type
            if arg.default_value:
                default_value_ending = " = " + arg.default_value
            ret += "$" + arg_name + argument_type + default_value_ending + separator
        return ret.rstrip(separator)
    
    func merge_with(var other: GQLTemplate):
        var other_arguments = other.get_arguments()
        for key in other_arguments.keys():
            if not _arguments.has(key):
                _arguments[key] = other_arguments[key]
        
        set_body(get_body() + other.get_body())
    
    func set_body(var body: String):
        _body = body
    
    func get_body() -> String:
        return _body


class GQLBuilder:
    extends Reference
    
    const tamplates_path = "res://addons/enjin/sdk/graphql/templates/"
    
    var fragment_db: Dictionary = {}
    var query_db: Dictionary = {}
    var mutation_db: Dictionary = {}
    
    func register_ql(var gql_file_path: String):
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
                if is_query and not query_db.has(key):
                    query_db[key] = GQLTemplate.new(gql_file_path)
                if is_mutation and not mutation_db.has(key):
                    mutation_db[key] = GQLTemplate.new(gql_file_path)
                if is_fragment and not fragment_db.has(key):
                    fragment_db[key] = GQLTemplate.new(gql_file_path)
                break
            
    func scan(var path: Array, var curr_folder: String):
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
                        scan(path, curr_folder + file + "/")
                else:
                    register_ql(curr_folder + file)
    
    func _init():
        pass
    
    func scan_all():
        scan([], tamplates_path)
    
    func get_query_db() -> Dictionary:
        return query_db

    func get_mutation_db() -> Dictionary:
        return mutation_db

    func get_fragment_db() -> Dictionary:
        return fragment_db
    
    func add_folder(var path: String):
        var folders = path.get_base_dir().trim_prefix(self.tamplates_path)
        
        #Re-scan (probably not necessary)
        var node_path = NodePath(folders)
        var key_array = []
        for folder_id in range(0, node_path.get_name_count()):
            var folder = node_path.get_name(folder_id)
            key_array.append(folder)
        
        scan(key_array, path)
    
    func read_ql(var gql_file_path: String, var in_gql_template: GQLTemplate) -> GQLTemplate:
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
            
            if is_query and query_db.has(key):
                gql_template = query_db[key]
            if is_mutation and mutation_db.has(key):
                gql_template = mutation_db[key]
            if is_fragment and fragment_db.has(key):
                gql_template = fragment_db[key]
            
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
                
                gql_template.add_argument(argument_name, type, default_value)

            if is_fragment_reference:
                #Find fragment in DB
                var fragment_name = tmp_line.trim_prefix("...")
                if fragment_db.has(fragment_name):
                    #Found fragment, include
                    includes.append(fragment_name)
            
            if not is_argument:
                ret += line + "\n"

        if gql_template:
            gql_template.set_body(ret)

        for include in includes:
            var tmp_template = read_ql(fragment_db[include].get_path(), gql_template)
            if gql_template:
                gql_template.merge_with(tmp_template)

        return gql_template

static func find_template(var query_name) -> GQLTemplate:
    var gql_builder = GQLBuilder.new()
    
    gql_builder.add_folder(GQLBuilder.tamplates_path)
    var query_db = gql_builder.get_query_db()
    var mutation_db = gql_builder.get_mutation_db()
    
    var query_template = null
    
    if query_db.has(query_name):
        query_template = gql_builder.read_ql(query_db[query_name].get_path(), null)
        return query_template
    if mutation_db.has(query_name):
        query_template = gql_builder.read_ql(mutation_db[query_name].get_path(), null)
        return query_template
    
    return query_template

static func build_query(var query_name: String) -> String:
    var query_template = find_template(query_name)
    var query = query_template.get_body() % query_template.list_arguments(",\n")
    return query

static func build_query_request(var query_name: String, variables: Dictionary, operationName: String = "") -> String:
    var query = build_query(query_name)
    
    var request_body = {}
    request_body.query = query
    request_body.variables = variables
    if operationName != "":
        request_body.operationName = operationName
    else:
        request_body.operationName = query_name
    
    return request_body
