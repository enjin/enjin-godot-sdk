extends "res://addons/enjin/sdk/schemas/shared/arguments/BaseArgument.gd"

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_meta() -> EnjinGraphqlRequest:
    return set_variable("with_meta", true)

func with_encoded_data() -> EnjinGraphqlRequest:
    return set_variable("withEncodedData", true)

func with_token_data() -> EnjinGraphqlRequest:
    return set_variable("withTokenData", true)

func with_signed_txs() -> EnjinGraphqlRequest:
    return set_variable("withSignedTxs", true)

func with_error() -> EnjinGraphqlRequest:
    return set_variable("withError", true)

func with_nonce() -> EnjinGraphqlRequest:
    return set_variable("withNonce", true)

func with_state() -> EnjinGraphqlRequest:
    return set_variable("withState", true)

func with_receipt() -> EnjinGraphqlRequest:
    return set_variable("withReceipt", true)
