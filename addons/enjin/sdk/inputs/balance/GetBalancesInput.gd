extends "../BaseInput.gd"
class_name GetBalancesInput

const BalanceFragmentInput = preload("res://addons/enjin/sdk/inputs/balance/BalanceFragmentInput.gd").BalanceFragmentInput
const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var balance_i: BalanceFragmentInput
var paginated_i: PaginatedInput

func _init():
    balance_i = BalanceFragmentInput.new(vars)
    paginated_i = PaginatedInput.new(vars)

func app_ids(appIds: Array) -> GetBalancesInput:
    vars.appIds = appIds
    return self

func eth_addr(ethAddr: String) -> GetBalancesInput:
    vars.ethAddress = ethAddr
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
