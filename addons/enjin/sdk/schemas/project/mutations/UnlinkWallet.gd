extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name UnlinkWallet

func _init().("enjin.sdk.project.UnlinkWallet"):
    pass

func eth_address(eth_address: String) -> UnlinkWallet:
    set_variable("ethAddress", eth_address)
    return self
