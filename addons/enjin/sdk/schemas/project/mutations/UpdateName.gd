extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name UpdateName

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.UpdateName"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func token_id(token_id: String) -> UpdateName:
    set_variable("tokenId", token_id)
    return self

func token_index(token_index: String) -> UpdateName:
    set_variable("tokenIndex", token_index)
    return self

func name(name: String) -> UpdateName:
    set_variable("name", name)
    return self
