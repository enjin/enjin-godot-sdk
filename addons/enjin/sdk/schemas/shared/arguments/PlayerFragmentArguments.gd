extends "res://addons/enjin/sdk/schemas/shared/arguments/BaseArgument.gd"

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_linking_code() -> EnjinGraphqlRequest:
    return set_variable("withLinkingCode", true)

func with_linking_code_qr() -> EnjinGraphqlRequest:
    return set_variable("withLinkingCodeQr", true)

func with_wallet() -> EnjinGraphqlRequest:
    return set_variable("withWallet", true)

func qr_size(size: int) -> EnjinGraphqlRequest:
    return set_variable("linkingCodeQrSize", size)
