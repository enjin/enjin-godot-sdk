class WalletFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func bal_app_id(balAppId: int) -> WalletFragmentInput:
        vars.balAppId = balAppId
        return self

    func token_id(balTokenId: String) -> WalletFragmentInput:
        vars.balTokenId = balTokenId
        return self

    func bal_equal(balVal: int) -> WalletFragmentInput:
        vars.balVal = balVal
        return self

    func bal_greater_than(balGt: int) -> WalletFragmentInput:
        vars.balGt = balGt
        return self

    func bal_greater_than_or_equal(balGte: int) -> WalletFragmentInput:
        vars.balGte = balGte
        return self

    func bal_less_than(balLt: int) -> WalletFragmentInput:
        vars.balLt = balLt
        return self

    func bal_less_than_or_equal(balLte: int) -> WalletFragmentInput:
        vars.balLte = balLte
        return self

    func with_balances(withBalances: bool) -> WalletFragmentInput:
        vars.withBalances = withBalances
        return self

    func with_tokens_created(withTokensCreated: bool) -> WalletFragmentInput:
        vars.withTokensCreated = withTokensCreated
        return self
