extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name DecreaseMaxTransferFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.DecreaseMaxTransferFee"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> DecreaseMaxTransferFee:
    return set_variable("tokenId", token_id)

func token_index(token_index: String) -> DecreaseMaxTransferFee:
    return set_variable("tokenIndex", token_index)

func max_transfer_fee(max_transfer_fee: int) -> DecreaseMaxTransferFee:
    return set_variable("maxTransferFee", max_transfer_fee)
