class PaginatedInput extends "./BaseInput.gd":
    func _init(vars_in: Dictionary = {}).(vars_in):
        pass

    func page(page: int) -> PaginatedInput:
        _create_if_not_exists()
        vars.pagination.page = page
        return self

    func limit(limit: int) -> PaginatedInput:
        _create_if_not_exists()
        vars.pagination.limit = limit
        return self

    func _create_if_not_exists():
        if vars.pagination == null:
            vars.pagination = {}
