extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ProjectGetWallet

const WalletFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/WalletFragmentArguments.gd")

var wallet_i: WalletFragmentArguments

func _init().("enjin.sdk.project.GetWallet"):
    wallet_i = WalletFragmentArguments.new(self)

func user_id(user_id: String) -> ProjectGetWallet:
    return set_variable("userId", user_id)

func eth_address(eth_address: String) -> ProjectGetWallet:
    return set_variable("ethAddress", eth_address)
