extends "res://addons/enjin/sdk/schemas/shared/arguments/BaseArgument.gd"

var _pagination: Dictionary = {}

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func page(page: int) -> EnjinGraphqlRequest:
    _create_pagination()
    _pagination["page"] = page
    return owner

func limit(limit: int = 10) -> EnjinGraphqlRequest:
    _create_pagination()
    _pagination["limit"] = limit
    return owner

func _create_pagination():
    if not is_set("pagination"):
        set_variable("pagination", _pagination)
