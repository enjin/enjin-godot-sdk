extends BaseInput
class_name RoleFragmentInput

func _init(vars_in: Dictionary).(vars_in):
    pass

func with_permissions(withRolePermissions: bool) -> RoleFragmentInput:
    vars.withRolePermissions = withRolePermissions
    return self