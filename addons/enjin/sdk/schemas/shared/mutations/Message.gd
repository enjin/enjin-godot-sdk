extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name Message

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.Message"):
    tx_request_args = TransactionRequestArguments.new(self)

func message(message: String) -> Message:
    set_variable("message", message)
    return self
