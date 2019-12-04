extends "../BaseInput.gd"
class_name SearchInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)

func term(term: String) -> SearchInput:
    vars.term = term
    return self