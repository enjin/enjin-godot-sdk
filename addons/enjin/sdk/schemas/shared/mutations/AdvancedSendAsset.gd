extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name AdvancedSendAsset

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.AdvancedSendAsset"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func transfers(transfers: Array) -> AdvancedSendAsset:
    return set_variable("transfers", transfers)

func data(data: String) -> AdvancedSendAsset:
    return set_variable("data", data)
