extends "./BaseUserInput.gd"
class_name GetUsersInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)

func id(id: int) -> GetUsersInput:
    vars.id = id
    return self

func name(name: String) -> GetUsersInput:
    vars.name = name
    return self

func email(email: String) -> GetUsersInput:
    vars.email = email
    return self
