extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"
class_name TransactionSort

func _init().():
    pass

func field(field: String) -> TransactionSort:
    set_variable("field", field)
    return self

func direction(direction: String) -> TransactionSort:
    set_variable("direction", direction)
    return self
