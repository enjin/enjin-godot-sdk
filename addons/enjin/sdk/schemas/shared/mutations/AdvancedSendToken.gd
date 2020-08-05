extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name AdvancedSendToken

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.AdvancedSendToken"):
    tx_request_args = TransactionRequestArguments.new(self)

func transfers(transfers: Array) -> AdvancedSendToken:
    set_variable("transfers", transfers)
    return self

func data(data: String) -> AdvancedSendToken:
    set_variable("data", data)
    return self
