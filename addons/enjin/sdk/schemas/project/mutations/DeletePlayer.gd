extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name DeletePlayer

func _init().("enjin.sdk.project.DeletePlayer"):
    pass

func id(id: String) -> DeletePlayer:
    set_variable("id", id)
    return self
