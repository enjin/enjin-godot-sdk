extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CreateToken

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var tx_fragment_args: TransactionFragmentArguments
var tx_request_args: TransactionRequestArguments

func _init().("enjin.sdk.project.CreateToken"):
    tx_fragment_args = TransactionFragmentArguments.new(self)
    tx_request_args = TransactionRequestArguments.new(self)

func name(name: String) -> CreateToken:
    set_variable("name", name)
    return self

func total_supply(total_supply: String) -> CreateToken:
    set_variable("totalSupply", total_supply)
    return self

func initial_reserve(initial_reserve: String) -> CreateToken:
    set_variable("initialReserve", initial_reserve)
    return self

func supply_model(supply_model: String) -> CreateToken:
    set_variable("supplyModel", supply_model)
    return self

func melt_value(melt_value: String) -> CreateToken:
    set_variable("meltValue", melt_value)
    return self

func melt_fee_ratio(melt_fee_ratio: int) -> CreateToken:
    set_variable("meltFeeRatio", melt_fee_ratio)
    return self

func transferable(transferable: String) -> CreateToken:
    set_variable("transferable", transferable)
    return self

func transfer_fee_settings(settings: TokenTransferFeeSettings) -> CreateToken:
    set_variable("transferFeeSettings", settings.get_vars().duplicate())
    return self

func nonfungible(nonfungible: bool) -> CreateToken:
    set_variable("nonfungible", nonfungible)
    return self
