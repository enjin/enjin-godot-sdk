extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetTokens

const TokenFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TokenFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var token_fragment_args: TokenFragmentArguments
var pag_fragment_args: PaginationArguments

func _init().("enjin.sdk.shared.GetTokens"):
    token_fragment_args = TokenFragmentArguments.new(self)
    pag_fragment_args = PaginationArguments.new(self)

func filter(filter: TokenFilter) -> GetTokens:
    set_variable("filter", filter.get_vars().duplicate())
    return self

func sort(sort: TokenSort) -> GetTokens:
    set_variable("sort", sort.get_vars().duplicate())
    return self
