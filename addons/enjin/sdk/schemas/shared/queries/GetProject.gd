extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetProject

func _init().("enjin.sdk.shared.GetProject"):
    pass

func id(id: int) -> GetProject:
    set_variable("id", id)
    return self

func name(name: String) -> GetProject:
    set_variable("name", name)
    return self
