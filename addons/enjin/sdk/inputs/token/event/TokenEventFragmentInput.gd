class TokenEventFragmentInput extends "../../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func with_event_params(withEventParams: bool) -> TokenEventFragmentInput:
        vars.withEventParams = withEventParams
        return self

    func with_block_number(withBlockNumber: bool) -> TokenEventFragmentInput:
        vars.withBlockNumber = withBlockNumber
        return self

    func with_event_token(withEventToken: bool) -> TokenEventFragmentInput:
        vars.withEventToken = withEventToken
        return self

    func with_token_event_timestamps(withTokenEventTimestamps: bool) -> TokenEventFragmentInput:
        vars.withTokenEventTimestamps = withTokenEventTimestamps
        return self
