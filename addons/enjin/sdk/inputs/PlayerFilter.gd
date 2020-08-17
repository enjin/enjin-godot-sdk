extends "res://addons/enjin/sdk/inputs/Filter.gd"
class_name PlayerFilter

func _init().():
    pass

func id(id: String) -> PlayerFilter:
    set_variable("id", id)
    return self

func id_in(ids: Array) -> PlayerFilter:
    set_variable("id_in", ids)
    return self

func and_filters(others: Array) -> PlayerFilter:
    .and_filters(others)
    return self

func or_filters(others: Array) -> PlayerFilter:
    .or_filters(others)
    return self

