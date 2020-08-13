extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SendEnj

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.SendEnj"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func recipient_address(recipient_address: String) -> SendEnj:
    return set_variable("recipientAddress", recipient_address)

func value(value: String) -> SendEnj:
    return set_variable("value", value)
