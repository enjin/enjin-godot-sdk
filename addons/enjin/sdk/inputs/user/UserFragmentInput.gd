class UserFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func with_roles(withUserRoles: bool) -> UserFragmentInput:
        vars.withUserRoles = withUserRoles
        return self

    func with_identities(withUserIdentities: bool) -> UserFragmentInput:
        vars.withUserIdentities = withUserIdentities
        return self

    func with_timestamps(withUserTimestamps: bool) -> UserFragmentInput:
        vars.withUserTimestamps = withUserTimestamps
        return self
