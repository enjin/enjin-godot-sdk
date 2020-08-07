extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"
class_name TokenSort

func _init().():
    pass

func field(field: String) -> TokenSort:
    set_variable("field", field)
    return self

func direction(direction: String) -> TokenSort:
    set_variable("direction", direction)
    return self
