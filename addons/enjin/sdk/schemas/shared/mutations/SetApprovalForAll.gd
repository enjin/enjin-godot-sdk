extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetApprovalForAll

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.SetApprovalForAll"):
    tx_request_args = TransactionRequestArguments.new(self)

func operator_address(operator_address: String) -> SetApprovalForAll:
    set_variable("operatorAddress", operator_address)
    return self

func approved(approved: bool) -> SetApprovalForAll:
    set_variable("approved", approved)
    return self
