extends "../BaseInput.gd"

var role_i: EnjinSdkInputs.RoleFragmentInput

func _init():
    role_i = EnjinSdkInputs.RoleFragmentInput.new(vars)