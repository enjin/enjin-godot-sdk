extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequest

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")

var txn_i: TransactionFragmentArguments

func _init().("enjin.sdk.shared.GetRequest"):
    txn_i = TransactionFragmentArguments.new(self)

func id(id: int) -> GetRequest:
    return set_variable("id", id)

func transaction_id(id: String) -> GetRequest:
    return set_variable("transactionId", id)
