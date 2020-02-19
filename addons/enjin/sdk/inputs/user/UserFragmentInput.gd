class UserFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func with_user_access_tokens(withUserAccessTokens: bool) -> UserFragmentInput:
        vars.withUserAccessTokens = withUserAccessTokens
        return self

    func with_identities(withUserIdentities: bool) -> UserFragmentInput:
        vars.withUserIdentities = withUserIdentities
        return self

    func with_timestamps(withUserTimestamps: bool) -> UserFragmentInput:
        vars.withUserTimestamps = withUserTimestamps
        return self
