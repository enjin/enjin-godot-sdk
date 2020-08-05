extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SendEnj

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.SendEnj"):
    tx_request_args = TransactionRequestArguments.new(self)

func recipient_address(recipient_address: String) -> SendEnj:
    set_variable("recipientAddress", recipient_address)
    return self

func value(value: String) -> SendEnj:
    set_variable("value", value)
    return self
