extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CreatePlayer

func _init().("enjin.sdk.project.CreatePlayer"):
    pass

func id(id: String) -> CreatePlayer:
    set_variable("id", id)
    return self
