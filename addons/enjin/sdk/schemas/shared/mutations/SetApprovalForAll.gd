extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetApprovalForAll

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.shared.SetApprovalForAll"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func operator_address(operator_address: String) -> SetApprovalForAll:
    set_variable("operatorAddress", operator_address)
    return self

func approved(approved: bool) -> SetApprovalForAll:
    set_variable("approved", approved)
    return self
