extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name InvalidateAssetMetadata

func _init().("enjin.sdk.project.InvalidateAssetMetadata"):
    pass

func id(id: String) -> InvalidateAssetMetadata:
    return set_variable("id", id)
