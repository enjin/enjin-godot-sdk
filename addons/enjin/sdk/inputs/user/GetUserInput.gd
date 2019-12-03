extends "./BaseUserInput.gd"
class_name GetUserInput

func id(id: int) -> GetUserInput:
    vars.id = id
    return self

func name(name: String) -> GetUserInput:
    vars.name = name
    return self

func me(me: bool) -> GetUserInput:
    vars.me = me
    return self
