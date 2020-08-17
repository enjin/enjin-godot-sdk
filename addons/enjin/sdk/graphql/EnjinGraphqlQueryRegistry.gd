extends Reference

const FRAGMENT: String = "fragment"
const MUTATION: String = "mutation"
const QUERY: String = "query"
const TEMPLATE_REGEX: String = "^(?:[a-zA-Z\\/:]*schemas\\/)(?:player|project|shared)\\/(?<type>fragment|query|mutation)\\/(?:[a-zA-Z]+)\\.gql$"

const _sdk_template_path: String = "res://addons/enjin/sdk/graphql/templates/"
var _template_regex: RegEx = RegEx.new()
var _fragments: Dictionary setget , get_fragments
var _operations: Dictionary setget , get_operations

func _init():
    _template_regex.compile(TEMPLATE_REGEX)
    _load_templates()

func _load_templates():
    _load_templates_from_dir(_sdk_template_path)
    
    for operation in _operations.values():
        operation.compile()

func _load_templates_from_dir(path: String):
    var dir: Directory = Directory.new()
    var dir_queue: Array = [path]

    while not dir_queue.empty():
        var next_path: String = dir_queue.pop_front()

        if dir.change_dir(next_path) != OK:
            continue
        if dir.list_dir_begin(true, true) != OK:
            continue

        var current_dir: String = dir.get_current_dir()
        var file_name: String = dir.get_next()
        while file_name != "":
            var file_path: String = "%s/%s" % [current_dir, file_name]
            
            if dir.current_is_dir():
                dir_queue.push_back(file_path + "/")
            else:
                # Matches the file path with the regex.
                var matcher: RegExMatch = _template_regex.search(file_path)
                if matcher != null:
                    var type: String = matcher.get_string("type")
                    if type == FRAGMENT or type == QUERY or type == MUTATION:
                        _load_and_cache_template_contents(_load_template_contents(file_path), type)
            
            file_name = dir.get_next()
    
    dir.list_dir_end()

func _load_and_cache_template_contents(contents: Array, type: String):
    if contents == null or contents.empty():
        return
    
    var namespace: String = GraphqlTemplate.read_namespace(contents)
    if namespace == null:
        return
    
    if type == FRAGMENT:
        _fragments[namespace] = GraphqlTemplate.new(namespace, type, contents, _fragments)
    elif type == QUERY or type == MUTATION:
        _operations[namespace] = GraphqlTemplate.new(namespace, type, contents, _fragments)
    else:
        push_error("Unsupported template type")

func _load_template_contents(path: String) -> Array:
    var contents: Array = []
    var file: File = File.new()
    file.open(path, File.READ)
    
    while not file.eof_reached():
        contents.append(file.get_line())
    
    file.close()
    return contents

func get_fragments() -> Dictionary:
    return _fragments

func get_operations() -> Dictionary:
    return _operations

func get_template(template_name: String) -> GraphqlTemplate:
    if has_template(template_name):
        return _operations.get(template_name)
    return null

func has_template(template_name: String) -> bool:
    return _operations.has(template_name)

class GraphqlTemplate:
    const NAMESPACE_KEY = "#namespace"
    const IMPORT_KEY = "#import"
    const ARG_KEY = "#arg"
    
    var _namespace: String setget , get_namespace
    var _name: String setget , get_name
    var _template_type: String setget , get_template_type
    var _contents: String setget , get_contents
    var _compiled_contents: String setget , get_compiled_contents
    var _parameters: Array = [] setget , get_parameters
    var _referenced_fragments: Array = [] setget , get_referenced_fragments
    var _fragments: Dictionary
    
    func _init(name: String, template_type: String, contents: Array, fragments: Dictionary):
        var parts: Array = name.split(".")
        _namespace = name
        _name = parts[parts.size() - 1]
        _template_type = template_type
        _contents = _parse_contents(contents)
        _fragments = fragments
    
    func _parse_contents(contents: Array) -> String:
        var builder: PoolStringArray = []
        
        for line in contents:
            var trimmed: String = line.strip_edges()
            if trimmed.begins_with(ARG_KEY):
                _parameters.append(_process_arg(trimmed))
            elif trimmed.begins_with(IMPORT_KEY):
                _referenced_fragments.append(_process_import(trimmed))
            elif not trimmed.empty() and not trimmed.begins_with("#"):
                builder.append(line)
                builder.append("\n")
        
        return builder.join("").strip_edges()
    
    func compile():
        if _template_type == FRAGMENT:
            return
        
        var parameters: Array = Array(_parameters)
        var processed_fragments: Array = []
        var fragment_stack: Array = []
        var builder: PoolStringArray = []
        
        builder.append(_contents)
        builder.append('\n')
        
        for fragment in _referenced_fragments:
            fragment_stack.push_back(_fragments[fragment])
        
        while fragment_stack.size() > 0:
            var template: GraphqlTemplate = fragment_stack.pop_back()
            
            if processed_fragments.has(template.get_namespace()):
                continue
            
            for fragment in template.get_referenced_fragments():
                fragment_stack.push_back(_fragments[fragment])
            
            for parameter in template.get_parameters():
                if not parameters.has(parameter):
                    parameters.append(parameter)
            
            builder.append(template.get_contents())
            builder.append('\n')
            processed_fragments.append(template.get_namespace())
        
        var formatted_params: String = PoolStringArray(parameters).join(", ")
        _compiled_contents = builder.join("")\
                                    .replace(_template_type,\
                                             "%s %s(%s)" % [_template_type, _name, formatted_params])\
                                    .strip_edges()
    
    func get_namespace() -> String:
        return _namespace
    
    func get_name() -> String:
        return _name
    
    func get_template_type() -> String:
        return _template_type
    
    func get_contents() -> String:
        return _contents
    
    func get_compiled_contents() -> String:
        return _compiled_contents
    
    func get_parameters() -> Array:
        return _parameters
    
    func get_referenced_fragments() -> Array:
        return _referenced_fragments
    
    static func read_namespace(contents: Array):
        for line in contents:
            if line.begins_with(NAMESPACE_KEY):
                return line.split(" ")[1]
        return null
    
    static func _process_arg(line: String):
        var parts: Array = line.split(" ")
        match parts.size():
            3:
                return "$%s: %s" % [parts[1], parts[2]]
            4:
                return "$%s: %s = %s" % [parts[1], parts[2], parts[3]]
            _:
                push_error("Argument is of incorrect format")
    
    static func _process_import(line: String):
        return line.split(" ")[1]
