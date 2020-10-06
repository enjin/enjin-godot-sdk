extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetWallets

const WalletFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/WalletFragmentArguments.gd")

var wallet_i: WalletFragmentArguments

func _init().("enjin.sdk.project.GetWallets"):
    wallet_i = WalletFragmentArguments.new(self)

func user_ids(user_ids: Array) -> GetWallets:
    return set_variable("userIds", user_ids)

func eth_addresses(eth_addresses: Array) -> GetWallets:
    return set_variable("ethAddresses", eth_addresses)
