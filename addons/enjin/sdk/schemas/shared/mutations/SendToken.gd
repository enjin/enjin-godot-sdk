extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SendToken

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.SendToken"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func recipient_address(recipient_address: String) -> SendToken:
    set_variable("recipientAddress", recipient_address)
    return self

func token_id(token_id: String) -> SendToken:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> SendToken:
    set_variable("tokenIndex", token_index)
    return self

func value(value: String) -> SendToken:
    set_variable("value", value)
    return self

func data(data: String) -> SendToken:
    set_variable("data", data)
    return self
