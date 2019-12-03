extends "./BaseRoleInput.gd"
class_name CreateRoleInput

func name(name: String) -> CreateRoleInput:
    vars.name = name
    return self

func permissions(permissions: Array) -> CreateRoleInput:
    vars.permissions = permissions
    return self