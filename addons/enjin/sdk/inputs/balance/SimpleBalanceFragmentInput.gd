extends BaseInput
class_name SimpleBalanceFragmentInput

func _init(vars_in: Dictionary).(vars_in):
    pass

func id_format(balIdFormat: String) -> SimpleBalanceFragmentInput:
    vars.balIdFormat = balIdFormat
    return self

func index_format(balIndexFormat: String) -> SimpleBalanceFragmentInput:
    vars.balIndexFormat = balIndexFormat
    return self