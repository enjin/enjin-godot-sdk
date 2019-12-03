extends "./BaseRoleInput.gd"
class_name GetRolesInput

func id(id: int) -> GetRolesInput:
    vars.id = id
    return self

func name(name: String) -> GetRolesInput:
    vars.name = name
    return self