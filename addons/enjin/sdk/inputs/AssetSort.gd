extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"
class_name AssetSort

func _init().():
    pass

func field(field: String) -> AssetSort:
    set_variable("field", field)
    return self

func direction(direction: String) -> AssetSort:
    set_variable("direction", direction)
    return self
