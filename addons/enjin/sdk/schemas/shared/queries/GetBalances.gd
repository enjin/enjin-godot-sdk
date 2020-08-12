extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetBalances

const BalanceFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/BalanceFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var balance_i: BalanceFragmentArguments
var pagination_i: PaginationArguments

func _init().("enjin.sdk.shared.GetBalances"):
    balance_i = BalanceFragmentArguments.new(self)
    pagination_i = PaginationArguments.new(self)

func filter(filter: BalanceFilter) -> GetBalances:
    set_variable("filter", filter.get_vars().duplicate())
    return self
