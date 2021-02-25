extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetTransferFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.SetTransferFee"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func asset_id(asset_id: String) -> SetTransferFee:
    return set_variable("assetId", asset_id)

func asset_index(asset_index: String) -> SetTransferFee:
    return set_variable("assetIndex", asset_index)

func transfer_fee_settings(transfer_fee_settings: Object) -> SetTransferFee:
    return set_variable("transferFeeSettings", transfer_fee_settings)
