extends Reference

var _owner
var _vars: Dictionary setget , get_vars

func _init(owner_in = self):
    _owner = owner_in
    _vars = owner_in.get_vars()

func set_variable(key: String, value):
    _vars[key] = value
    return _owner

func is_set(key: String) -> bool:
    return _vars.has(key)

func get_vars() -> Dictionary:
    return _vars
