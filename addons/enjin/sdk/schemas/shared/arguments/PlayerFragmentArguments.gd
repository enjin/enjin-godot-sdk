extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_linking_info() -> EnjinGraphqlRequest:
    return set_variable("withLinkingInfo", true)

func with_wallet() -> EnjinGraphqlRequest:
    return set_variable("withPlayerWallet", true)

func qr_size(size: int) -> EnjinGraphqlRequest:
    return set_variable("linkingCodeQrSize", size)
