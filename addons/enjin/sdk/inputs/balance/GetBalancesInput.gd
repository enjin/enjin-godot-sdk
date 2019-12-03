extends "../BaseInput.gd"
class_name GetBalancesInput

var balance_i: EnjinSdkInputs.BalanceFragmentInput
var paginated_i: EnjinSdkInputs.PaginatedInput

func _init():
    balance_i = EnjinSdkInputs.BalanceFragmentInput.new(vars)
    paginated_i = EnjinSdkInputs.PaginatedInput.new(vars)

func app_id(appId: int) -> GetBalancesInput:
    vars.appId = appId
    return self

func token_id(tokenId: String) -> GetBalancesInput:
    vars.tokenId = tokenId
    return self

func value(value: int) -> GetBalancesInput:
    vars.value = value
    return self

func val_gt(valGt: int) -> GetBalancesInput:
    vars.valGt = valGt
    return self

func val_gte(valGte: int) -> GetBalancesInput:
    vars.valGte = valGte
    return self

func val_lt(valLt: int) -> GetBalancesInput:
    vars.valLt = valLt
    return self

func val_lte(valLte: int) -> GetBalancesInput:
    vars.valLte = valLte
    return self