extends UserFragmentInput
class_name GetUserInput

func id(id: int) -> GetUserInput:
    input.id = id
    return self

func name(name: String) -> GetUserInput:
    input.name = name
    return self

func me(me: bool) -> GetUserInput:
    input.me = me
    return self

func pagination(pagination: PaginationInput) -> GetUserInput:
    if pagination:
        input.pagination = pagination.create()
    return self
