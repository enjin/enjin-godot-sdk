extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ApproveEnj

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.ApproveEnj"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func value(value: String) -> ApproveEnj:
    set_variable("value", value)
    return self
