extends "../BaseInput.gd"

const RoleFragmentInput = preload("res://addons/enjin/sdk/inputs/role/RoleFragmentInput.gd").RoleFragmentInput

var role_i: RoleFragmentInput

func _init():
    role_i = RoleFragmentInput.new(vars)