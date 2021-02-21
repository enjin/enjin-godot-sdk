extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"
class_name AssetTransferFeeSettingsInput

func _init().():
    pass

func type(type: String) -> AssetTransferFeeSettingsInput:
    set_variable("type", type)
    return self

func asset_id(asset_id: String) -> AssetTransferFeeSettingsInput:
    set_variable("assetId", asset_id)
    return self

func value(value: String) -> AssetTransferFeeSettingsInput:
    set_variable("value", value)
    return self
