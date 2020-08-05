extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetBalances

const BalanceFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/BalanceFragmentArguments.gd")

var balance_arguments

func _init().("enjin.sdk.shared.GetBalances"):
    balance_arguments = BalanceFragmentArguments.new(self)

func filter(filter: Object) -> GetBalances:
    set_variable("filter", filter)
    return self
