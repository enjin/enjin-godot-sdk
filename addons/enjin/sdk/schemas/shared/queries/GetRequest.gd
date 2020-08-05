extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequest

const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")
const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")

var pag_fragment_args: PaginationArguments
var tx_fragment_args: TransactionFragmentArguments

func _init().("enjin.sdk.shared.GetRequest"):
    pag_fragment_args = PaginationArguments.new(self)
    tx_fragment_args = TransactionFragmentArguments.new(self)

func id(id: int) -> GetRequest:
    set_variable("id", id)
    return self

func transaction_id(id: String) -> GetRequest:
    set_variable("transactionId", id)
    return self
