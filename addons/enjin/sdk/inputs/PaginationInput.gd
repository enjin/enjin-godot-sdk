extends BaseInput
class_name PaginationInput

func page(page: int) -> PaginationInput:
    input.page = page
    return self

func limit(limit: int) -> PaginationInput:
    input.limit = limit
    return self