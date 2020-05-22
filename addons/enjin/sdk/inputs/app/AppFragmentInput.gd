class AppFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func with_secret(withSecret: bool) -> AppFragmentInput:
        vars.withSecret = withSecret
        return self

    func with_linking_code(withLinkingCode: bool) -> AppFragmentInput:
        vars.withLinkingCode = withLinkingCode
        return self

    func with_linking_code_qr(withLinkingCodeQr: bool) -> AppFragmentInput:
        vars.withLinkingCodeQr = withLinkingCodeQr
        return self

    func linking_code_qr_size(linkingCodeQrSize: int) -> AppFragmentInput:
        vars.linkingCodeQrSize = linkingCodeQrSize
        return self

    func with_current_user_identity(withCurrentUserIdentity: bool) -> AppFragmentInput:
        vars.withCurrentUserIdentity = withCurrentUserIdentity
        return self

    func with_owner(withOwner: bool) -> AppFragmentInput:
        vars.withOwner = withOwner
        return self

    func with_token_count(withTokenCount: bool) -> AppFragmentInput:
        vars.withTokenCount = withTokenCount
        return self

    func with_app_timestamps(withAppTimestamps: bool) -> AppFragmentInput:
        vars.withAppTimestamps = withAppTimestamps
        return self
