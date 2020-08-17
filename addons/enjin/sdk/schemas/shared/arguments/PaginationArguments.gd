extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

var _pagination: Dictionary = {}

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func page(page: int) -> EnjinGraphqlRequest:
    _create_pagination()
    _pagination["page"] = page
    return _owner

func limit(limit: int = 10) -> EnjinGraphqlRequest:
    _create_pagination()
    _pagination["limit"] = limit
    return _owner

func _create_pagination():
    if not is_set("pagination"):
        set_variable("pagination", _pagination)
