extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name DecreaseMaxMeltFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.DecreaseMaxMeltFee"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func asset_id(asset_id: String) -> DecreaseMaxMeltFee:
    return set_variable("assetId", asset_id)

func asset_index(asset_index: String) -> DecreaseMaxMeltFee:
    return set_variable("assetIndex", asset_index)

func max_melt_fee(max_melt_fee: int) -> DecreaseMaxMeltFee:
    return set_variable("maxMeltFee", max_melt_fee)
