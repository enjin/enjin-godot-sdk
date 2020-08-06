extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name InvalidateTokenMetadata

func _init().("enjin.sdk.project.InvalidateTokenMetadata"):
    pass

func id(id: String) -> InvalidateTokenMetadata:
    set_variable("id", id)
    return self
