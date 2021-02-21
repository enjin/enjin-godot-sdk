extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name MintAsset

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.MintAsset"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func asset_id(asset_id: String) -> MintAsset:
    return set_variable("assetId", asset_id)

func mints(mints: Array) -> MintAsset:
    return set_variable("mints", mints)
