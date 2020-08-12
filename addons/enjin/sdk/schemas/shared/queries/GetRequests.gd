extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequests

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var txn_i: TransactionFragmentArguments
var pagination_i: PaginationArguments

func _init().("enjin.sdk.shared.GetRequests"):
    txn_i = TransactionFragmentArguments.new(self)
    pagination_i = PaginationArguments.new(self)

func filter(filter: TransactionFilter) -> GetRequests:
    set_variable("filter", filter.get_vars().duplicate())
    return self

func sort(sort: TransactionSort) -> GetRequests:
    set_variable("sort", sort.get_vars().duplicate())
    return self
