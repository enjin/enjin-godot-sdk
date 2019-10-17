extends Reference
class_name EnjinUserInput

var input: Dictionary = {}

func id(id: int) -> EnjinUserInput:
    input.id = id
    return self

func name(name: String) -> EnjinUserInput:
    input.name = name
    return self

func me(me: bool) -> EnjinUserInput:
    input.me = me
    return self

func create() -> Dictionary:
    return input