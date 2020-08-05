extends Reference

var _vars: Dictionary = {} setget , get_vars
var _namespace: String setget , get_namespace

func _init(namespace: String):
    _namespace = namespace

func set(key: String, value):
    _vars[key] = value
    return self

func is_set(key: String) -> bool:
    return _vars.has(key)

func get_vars() -> Dictionary:
    return _vars

func get_namespace() -> String:
    return _namespace
