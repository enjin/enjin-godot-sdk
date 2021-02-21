extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name AuthProject

func _init().("enjin.sdk.project.AuthProject"):
    pass

func id(id: int) -> AuthProject:
    return set_variable("id", id)

func secret(secret: String) -> AuthProject:
    return set_variable("secret", secret)
