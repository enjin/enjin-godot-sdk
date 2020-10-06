extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name ProjectUnlinkWallet

func _init().("enjin.sdk.project.UnlinkWallet"):
    pass

func eth_address(eth_address: String) -> ProjectUnlinkWallet:
    return set_variable("address", eth_address)
