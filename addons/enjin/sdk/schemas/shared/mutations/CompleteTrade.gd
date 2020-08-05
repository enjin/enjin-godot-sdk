extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CompleteTrade

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.CompleteTrade"):
    tx_request_args = TransactionRequestArguments.new(self)

func trade_id(id: String) -> CompleteTrade:
    set_variable("tradeId", id)
    return self
