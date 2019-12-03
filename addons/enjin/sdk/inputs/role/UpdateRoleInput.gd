extends "./BaseRoleInput.gd"
class_name UpdateRoleInput

func name(name: String) -> UpdateRoleInput:
    vars.name = name
    return self

func new_name(newName: String) -> UpdateRoleInput:
    vars.newName = newName
    return self

func permissions(permissions: Array) -> UpdateRoleInput:
    vars.permissions = permissions
    return self