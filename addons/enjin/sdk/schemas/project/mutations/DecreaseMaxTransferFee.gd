extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name DecreaseMaxTransferFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.project.DecreaseMaxTransferFee"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    tx_request_args = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> DecreaseMaxTransferFee:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> DecreaseMaxTransferFee:
    set_variable("tokenIndex", token_index)
    return self

func max_transfer_fee(max_transfer_fee: int) -> DecreaseMaxTransferFee:
    set_variable("maxTransferFee", max_transfer_fee)
    return self
