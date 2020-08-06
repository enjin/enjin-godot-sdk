extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetWhitelisted

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.project.SetWhitelisted"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    tx_request_args = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> SetWhitelisted:
    set_variable("tokenId", token_id)
    return self

func account_address(account_address: String) -> SetWhitelisted:
    set_variable("accountAddress", account_address)
    return self

func whitelisted(whitelisted: Object) -> SetWhitelisted:
    set_variable("whitelisted", whitelisted)
    return self

func whitelisted_address(whitelisted_address: String) -> SetWhitelisted:
    set_variable("whitelistedAddress", whitelisted_address)
    return self

func on(on: bool) -> SetWhitelisted:
    set_variable("on", on)
    return self
