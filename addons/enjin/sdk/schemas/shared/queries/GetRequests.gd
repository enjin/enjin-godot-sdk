extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequests

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")

var tx_fragment_args: TransactionFragmentArguments

func _init().("enjin.sdk.shared.GetRequests"):
    tx_fragment_args = TransactionFragmentArguments.new(self)

func filter(filter: Object) -> GetRequests:
    set_variable("filter", filter)
    return self

func sort(sort: Object) -> GetRequests:
    set_variable("sort", sort)
    return self
