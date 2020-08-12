extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetToken

const TokenFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TokenFragmentArguments.gd")

var token_i: TokenFragmentArguments

func _init().("enjin.sdk.shared.GetToken"):
    token_i = TokenFragmentArguments.new(self)

func id(id: String) -> GetToken:
    set_variable("id", id)
    return self
