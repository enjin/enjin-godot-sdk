extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ReleaseReserve

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.project.ReleaseReserve"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    tx_request_args = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> ReleaseReserve:
    set_variable("tokenId", token_id)
    return self

func value(value: String) -> ReleaseReserve:
    set_variable("value", value)
    return self
