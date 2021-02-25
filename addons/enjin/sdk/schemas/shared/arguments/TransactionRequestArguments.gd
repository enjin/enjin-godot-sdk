extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func eth_address(eth_address: String) -> EnjinGraphqlRequest:
    return set_variable("ethAddress", eth_address)

func send(send: bool) -> EnjinGraphqlRequest:
    return set_variable("send", send)
