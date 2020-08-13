extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name MintToken

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.MintToken"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> MintToken:
    return set_variable("tokenId", token_id)

func mints(mints: Array) -> MintToken:
    return set_variable("mints", mints)
