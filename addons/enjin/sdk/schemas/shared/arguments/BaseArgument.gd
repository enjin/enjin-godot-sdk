extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

var _owner: EnjinGraphqlRequest

func _init(owner_in: EnjinGraphqlRequest).(owner_in.get_vars()):
    _owner = owner_in

func set_variable(key: String, value) -> EnjinGraphqlRequest:
    .set_variable(key, value)
    return _owner
