extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ApproveMaxEnj

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.ApproveMaxEnj"):
    tx_request_args = TransactionRequestArguments.new(self)
