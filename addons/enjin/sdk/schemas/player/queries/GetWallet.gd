extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name PlayerGetWallet

const WalletFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/WalletFragmentArguments.gd")

var wallet_i: WalletFragmentArguments

func _init().("enjin.sdk.player.GetWallet"):
    wallet_i = WalletFragmentArguments.new(self)
