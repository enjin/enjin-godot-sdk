extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name CreateAsset

const TransactionFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionFragmentArguments.gd")
const TransactionRequestArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/TransactionRequestArguments.gd")

var txn_i: TransactionFragmentArguments
var txn_request_i: TransactionRequestArguments

func _init().("enjin.sdk.project.CreateAsset"):
    txn_i = TransactionFragmentArguments.new(self)
    txn_request_i = TransactionRequestArguments.new(self)

func name(name: String) -> CreateAsset:
    return set_variable("name", name)

func total_supply(total_supply: String) -> CreateAsset:
    return set_variable("totalSupply", total_supply)

func initial_reserve(initial_reserve: String) -> CreateAsset:
    return set_variable("initialReserve", initial_reserve)

func supply_model(supply_model: String) -> CreateAsset:
    return set_variable("supplyModel", supply_model)

func melt_value(melt_value: String) -> CreateAsset:
    return set_variable("meltValue", melt_value)

func melt_fee_ratio(melt_fee_ratio: int) -> CreateAsset:
    return set_variable("meltFeeRatio", melt_fee_ratio)

func transferable(transferable: String) -> CreateAsset:
    return set_variable("transferable", transferable)

func transfer_fee_settings(settings: AssetTransferFeeSettingsInput) -> CreateAsset:
    return set_variable("transferFeeSettings", settings.get_vars().duplicate())

func nonFungible(nonFungible: bool) -> CreateAsset:
    return set_variable("nonFungible", nonFungible)
