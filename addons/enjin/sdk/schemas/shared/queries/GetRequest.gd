extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequest

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")

var tx_fragment_args: TransactionFragmentArguments

func _init().("enjin.sdk.shared.GetRequest"):
    tx_fragment_args = TransactionFragmentArguments.new(self)

func id(id: int) -> GetRequest:
    set_variable("id", id)
    return self

func transaction_id(id: String) -> GetRequest:
    set_variable("transactionId", id)
    return self
