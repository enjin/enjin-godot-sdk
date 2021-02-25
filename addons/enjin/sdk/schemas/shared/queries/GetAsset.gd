extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetAsset

const AssetFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/AssetFragmentArguments.gd")

var asset_i: AssetFragmentArguments

func _init().("enjin.sdk.shared.GetAsset"):
    asset_i = AssetFragmentArguments.new(self)

func id(id: String) -> GetAsset:
    return set_variable("id", id)
