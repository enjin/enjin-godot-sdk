extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

func _init().():
    pass

func and_filters(others: Array):
    set_variable("and", others)
    return self

func or_filters(others: Array):
    set_variable("or", others)
    return self
