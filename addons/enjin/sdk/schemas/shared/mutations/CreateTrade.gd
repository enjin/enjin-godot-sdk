extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CreateTrade

const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.shared.CreateTrade"):
    tx_request_args = TransactionRequestArguments.new(self)

func asking_tokens(tokens: Array) -> CreateTrade:
    set_variable("askingTokens", tokens)
    return self

func offering_tokens(tokens: Array) -> CreateTrade:
    set_variable("offeringTokens", tokens)
    return self

func recipient_address(recipient_address: String) -> CreateTrade:
    set_variable("recipientAddress", recipient_address)
    return self
