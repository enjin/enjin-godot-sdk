extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ReleaseReserve

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.ReleaseReserve"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func asset_id(asset_id: String) -> ReleaseReserve:
    return set_variable("assetId", asset_id)

func value(value: String) -> ReleaseReserve:
    return set_variable("value", value)
