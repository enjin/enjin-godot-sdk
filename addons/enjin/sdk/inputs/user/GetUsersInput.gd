extends "./GetUserInput.gd"
class_name GetUsersInput

var paginated_i: EnjinSdkInputs.PaginatedInput

func _init():
    paginated_i = EnjinSdkInputs.PaginatedInput.new(vars)