extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CancelTransaction

func _init().("enjin.sdk.shared.CancelTransaction"):
    pass

func id(id: int) -> CancelTransaction:
    return set_variable("id", id)
