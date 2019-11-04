extends Reference
class_name GetUserInput

var input: Dictionary = {}

func id(id: int) -> GetUserInput:
    input.id = id
    return self

func name(name: String) -> GetUserInput:
    input.name = name
    return self

func me(me: bool) -> GetUserInput:
    input.me = me
    return self

func create() -> Dictionary:
    return input