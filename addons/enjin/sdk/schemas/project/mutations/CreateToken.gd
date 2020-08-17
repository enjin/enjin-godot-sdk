extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CreateToken

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.CreateToken"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func name(name: String) -> CreateToken:
    return set_variable("name", name)

func total_supply(total_supply: String) -> CreateToken:
    return set_variable("totalSupply", total_supply)

func initial_reserve(initial_reserve: String) -> CreateToken:
    return set_variable("initialReserve", initial_reserve)

func supply_model(supply_model: String) -> CreateToken:
    return set_variable("supplyModel", supply_model)

func melt_value(melt_value: String) -> CreateToken:
    return set_variable("meltValue", melt_value)

func melt_fee_ratio(melt_fee_ratio: int) -> CreateToken:
    return set_variable("meltFeeRatio", melt_fee_ratio)

func transferable(transferable: String) -> CreateToken:
    return set_variable("transferable", transferable)

func transfer_fee_settings(settings: TokenTransferFeeSettings) -> CreateToken:
    return set_variable("transferFeeSettings", settings.get_vars().duplicate())

func nonfungible(nonfungible: bool) -> CreateToken:
    return set_variable("nonfungible", nonfungible)
