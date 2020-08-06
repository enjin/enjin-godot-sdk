extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetTransferFee

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.project.SetTransferFee"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    tx_request_args = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> SetTransferFee:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> SetTransferFee:
    set_variable("tokenIndex", token_index)
    return self

func transfer_fee_settings(transfer_fee_settings: Object) -> SetTransferFee:
    set_variable("transferFeeSettings", transfer_fee_settings)
    return self
