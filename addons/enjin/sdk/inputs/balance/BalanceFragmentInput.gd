class BalanceFragmentInput extends "../BaseInput.gd":
    func _init(vars_in: Dictionary).(vars_in):
        pass

    func id_format(balIdFormat: String) -> BalanceFragmentInput:
        vars.balIdFormat = balIdFormat
        return self

    func index_format(balIndexFormat: String) -> BalanceFragmentInput:
        vars.balIndexFormat = balIndexFormat
        return self
