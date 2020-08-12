extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name DecreaseMaxMeltFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.DecreaseMaxMeltFee"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> DecreaseMaxMeltFee:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> DecreaseMaxMeltFee:
    set_variable("tokenIndex", token_index)
    return self

func max_melt_fee(max_melt_fee: int) -> DecreaseMaxMeltFee:
    set_variable("maxMeltFee", max_melt_fee)
    return self
