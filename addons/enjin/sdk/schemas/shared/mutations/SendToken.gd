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
    return set_variable("recipientAddress", recipient_address)

func token_id(token_id: String) -> SendToken:
    return set_variable("tokenId", token_id)

func token_index(token_index: String) -> SendToken:
    return set_variable("tokenIndex", token_index)

func value(value: String) -> SendToken:
    return set_variable("value", value)

func data(data: String) -> SendToken:
    return set_variable("data", data)
