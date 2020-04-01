class IdentityFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func with_wallet(withWallet: bool) -> IdentityFragmentInput:
        vars.withWallet = withWallet
        return self

    func with_linking_code(withLinkingCode: bool) -> IdentityFragmentInput:
        vars.withLinkingCode = withLinkingCode
        return self

    func with_linking_code_qr(withLinkingCodeQr: bool) -> IdentityFragmentInput:
        vars.withLinkingCodeQr = withLinkingCodeQr
        return self

    func linking_code_qr_size(linkingCodeQrSize: int) -> IdentityFragmentInput:
        vars.linkingCodeQrSize = linkingCodeQrSize
        return self

    func with_timestamps(withIdentityTimestamps: bool) -> IdentityFragmentInput:
        vars.withIdentityTimestamps = withIdentityTimestamps
        return self
