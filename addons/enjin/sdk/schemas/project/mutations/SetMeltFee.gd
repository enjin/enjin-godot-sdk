extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetMeltFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.SetMeltFee"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> SetMeltFee:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> SetMeltFee:
    set_variable("tokenIndex", token_index)
    return self

func melt_fee(melt_fee: int) -> SetMeltFee:
    set_variable("meltFee", melt_fee)
    return self
