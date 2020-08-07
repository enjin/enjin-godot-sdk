extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"
class_name TokenTransferFeeSettings

func _init().():
    pass

func type(type: String) -> TokenTransferFeeSettings:
    set_variable("type", type)
    return self

func token_id(token_id: String) -> TokenTransferFeeSettings:
    set_variable("tokenId", token_id)
    return self

func value(value: String) -> TokenTransferFeeSettings:
    set_variable("value", value)
    return self
