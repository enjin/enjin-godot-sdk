extends Reference

var _vars: Dictionary setget , get_vars

func _init(vars: Dictionary = {}):
    _vars = vars

func set_variable(key: String, value):
    _vars[key] = value
    return self

func is_set(key: String) -> bool:
    return _vars.has(key)

func get_vars() -> Dictionary:
    return _vars
