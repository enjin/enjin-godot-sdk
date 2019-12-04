class TransactionFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func events_id(eventsId: int) -> TransactionFragmentInput:
        vars.eventsId = eventsId
        return self

    func events_type(eventsType: String) -> TransactionFragmentInput:
        vars.eventsType = eventsType
        return self

    func with_token_data(withTokenData: bool) -> TransactionFragmentInput:
        vars.withTokenData = withTokenData
        return self

    func with_meta(withMeta: bool) -> TransactionFragmentInput:
        vars.withMeta = withMeta
        return self

    func with_error(withError: bool) -> TransactionFragmentInput:
        vars.withError = withError
        return self

    func with_encoded_data(withEncodedData: bool) -> TransactionFragmentInput:
        vars.withEncodedData = withEncodedData
        return self

    func with_signed_txs(withSignedTxs: bool) -> TransactionFragmentInput:
        vars.withSignedTxs = withSignedTxs
        return self

    func with_nonce(withNonce: bool) -> TransactionFragmentInput:
        vars.withNonce = withNonce
        return self

    func with_state(withState: bool) -> TransactionFragmentInput:
        vars.withState = withState
        return self

    func with_receipt(withReceipt: bool) -> TransactionFragmentInput:
        vars.withReceipt = withReceipt
        return self

    func with_events(withEvents: bool) -> TransactionFragmentInput:
        vars.withEvents = withEvents
        return self

    func with_request_timestamps(withRequestTimestamps: bool) -> TransactionFragmentInput:
        vars.withRequestTimestamps = withRequestTimestamps
        return self
