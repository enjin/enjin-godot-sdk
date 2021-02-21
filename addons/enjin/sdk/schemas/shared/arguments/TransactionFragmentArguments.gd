extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")

func _init(owner_in: EnjinGraphqlRequest).(owner_in):
    pass

func with_blockchain_data() -> EnjinGraphqlRequest:
    return set_variable("withBlockchainData", true)

func with_meta() -> EnjinGraphqlRequest:
    return set_variable("withMeta", true)

func with_encoded_data() -> EnjinGraphqlRequest:
    return set_variable("withEncodedData", true)

func with_asset_data() -> EnjinGraphqlRequest:
    return set_variable("withAssetData", true)

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

func with_receipt_logs() -> EnjinGraphqlRequest:
    return set_variable("withReceiptLogs", true)

func with_log_event() -> EnjinGraphqlRequest:
    return set_variable("withLogEvent", true)
