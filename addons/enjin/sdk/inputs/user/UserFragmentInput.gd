class UserFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func user_app_id(userAppId: int) -> UserFragmentInput:
        vars.userAppId = userAppId
        return self

    func with_user_access_tokens(withUserAccessTokens: bool) -> UserFragmentInput:
        vars.withUserAccessTokens = withUserAccessTokens
        return self

    func with_identities(withUserIdentities: bool) -> UserFragmentInput:
        vars.withUserIdentities = withUserIdentities
        return self

    func with_timestamps(withUserTimestamps: bool) -> UserFragmentInput:
        vars.withUserTimestamps = withUserTimestamps
        return self
