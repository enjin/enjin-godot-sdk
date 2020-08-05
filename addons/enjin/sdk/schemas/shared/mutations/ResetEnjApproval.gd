extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ResetEnjApproval

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.ResetEnjApproval"):
    tx_request_args = TransactionRequestArguments.new(self)
