extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name UnlinkPlayerWallet

func _init().("enjin.sdk.project.UnlinkPlayerWallet"):
    pass

func eth_address(eth_address: String) -> UnlinkPlayerWallet:
    return set_variable("address", eth_address)
