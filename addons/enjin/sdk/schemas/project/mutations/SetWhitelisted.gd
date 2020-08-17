extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name SetWhitelisted

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.SetWhitelisted"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> SetWhitelisted:
    return set_variable("tokenId", token_id)

func account_address(account_address: String) -> SetWhitelisted:
    return set_variable("accountAddress", account_address)

func whitelisted(whitelisted: Object) -> SetWhitelisted:
    return set_variable("whitelisted", whitelisted)

func whitelisted_address(whitelisted_address: String) -> SetWhitelisted:
    return set_variable("whitelistedAddress", whitelisted_address)

func on(on: bool) -> SetWhitelisted:
    return set_variable("on", on)
