extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name AuthPlayer

func _init().("enjin.sdk.project.AuthPlayer"):
    pass

func id(id: String) -> AuthPlayer:
    return set_variable("id", id)
