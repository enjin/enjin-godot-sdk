extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetTokens

const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")
const TokenFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TokenFragmentArguments.gd")

var pag_fragment_args: PaginationArguments
var token_fragment_args: TokenFragmentArguments

func _init().("enjin.sdk.shared.GetTokens"):
    pag_fragment_args = PaginationArguments.new(self)
    token_fragment_args = TokenFragmentArguments.new(self)

func filter(filter: Object) -> GetTokens:
    set_variable("filter", filter)
    return self

func sort(sort: Object) -> GetTokens:
    set_variable("sort", sort)
    return self
