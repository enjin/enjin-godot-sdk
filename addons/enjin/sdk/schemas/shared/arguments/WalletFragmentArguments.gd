extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_assets_created() -> EnjinGraphqlRequest:
    return set_variable("withAssetsCreated", true)
