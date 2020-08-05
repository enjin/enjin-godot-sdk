extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ApproveEnj

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.ApproveEnj"):
    tx_request_args = TransactionRequestArguments.new(self)

func value(value: String) -> ApproveEnj:
    set_variable("value", value)
    return self
