extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetBalances

const BalanceFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/BalanceFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var balance_arguments: BalanceFragmentArguments
var pag_arguments: PaginationArguments

func _init().("enjin.sdk.shared.GetBalances"):
    balance_arguments = BalanceFragmentArguments.new(self)
    pag_arguments = PaginationArguments.new(self)

func filter(filter: BalanceFilter) -> GetBalances:
    set_variable("filter", filter.get_vars().duplicate())
    return self
