extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SendAsset

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.SendAsset"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func recipient_address(recipient_address: String) -> SendAsset:
    return set_variable("recipientAddress", recipient_address)

func asset_id(asset_id: String) -> SendAsset:
    return set_variable("assetId", asset_id)

func asset_index(asset_index: String) -> SendAsset:
    return set_variable("assetIndex", asset_index)

func value(value: String) -> SendAsset:
    return set_variable("value", value)

func data(data: String) -> SendAsset:
    return set_variable("data", data)
