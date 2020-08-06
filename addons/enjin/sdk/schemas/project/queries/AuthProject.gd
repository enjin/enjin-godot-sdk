extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name AuthProject

func _init().("enjin.sdk.project.AuthProject"):
    pass

func id(id: int) -> AuthProject:
    set_variable("appId", id)
    return self

func secret(secret: String) -> AuthProject:
    set_variable("secret", secret)
    return self
