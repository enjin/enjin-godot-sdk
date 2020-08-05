extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name MeltToken

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.MeltToken"):
    tx_request_args = TransactionRequestArguments.new(self)

func melt(melts: Array) -> MeltToken:
    set_variable("melts", melts)
    return self
