extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetRequests

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var pag_fragment_args: PaginationArguments

func _init().("enjin.sdk.shared.GetRequests"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    pag_fragment_args = PaginationArguments.new(self)

func filter(filter: TransactionFilter) -> GetRequests:
    set_variable("filter", filter.get_vars().duplicate())
    return self

func sort(sort: TransactionSort) -> GetRequests:
    set_variable("sort", sort.get_vars().duplicate())
    return self
