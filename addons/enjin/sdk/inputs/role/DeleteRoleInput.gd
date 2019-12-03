extends "./BaseRoleInput.gd"
class_name DeleteRoleInput

func id(id: int) -> DeleteRoleInput:
    vars.id = id
    return self

func name(name: String) -> DeleteRoleInput:
    vars.name = name
    return self