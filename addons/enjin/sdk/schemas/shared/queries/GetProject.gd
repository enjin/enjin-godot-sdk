extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetProject

func _init().("enjin.sdk.shared.GetProject"):
    pass

func id(id: int) -> GetProject:
    return set_variable("id", id)

func name(name: String) -> GetProject:
    return set_variable("name", name)
