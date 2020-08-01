extends Reference
class_name GraphqlTemplate

var _path: String setget ,get_path
var _name: String
var _arguments: Dictionary = {} setget ,get_arguments
var _fragment_refs: Array = []
var _raw_template: String = "" setget set_raw_template,get_raw_template
var _compiled_template: String = "" setget ,get_compiled_template
var _is_cached: bool = false

func _init(path: String, name: String):
    _path = path
    _name = name

func add_argument(arg: GraphqlArgument):
    if not _arguments.has(arg._name):
        _arguments[arg._name] = arg

func add_fragment_ref(fragment: String):
    var name = fragment.replace("...", "")
    if !_fragment_refs.has(name):
        _fragment_refs.push_back(name)

func append_line(line: String):
    _raw_template += line

func set_raw_template(raw_template: String):
    _raw_template = raw_template

func get_path() -> String:
    return _path

func get_arguments() -> Dictionary:
    return _arguments

func get_fragment_refs() -> Array:
    return _fragment_refs

func get_raw_template() -> String:
    return _raw_template

func get_compiled_template() -> String:
    return _compiled_template
