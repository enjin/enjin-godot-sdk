extends "./GetUserInput.gd"
class_name GetUsersInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)