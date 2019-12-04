extends "./BaseAppInput.gd"
class_name GetAppInput

func id(id: int) -> GetAppInput:
    vars.id = id
    return self

func name(name: String) -> GetAppInput:
    vars.name = name
    return self

func me(me: bool) -> GetAppInput:
    vars.me = me
    return self