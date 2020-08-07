extends "res://addons/enjin/sdk/inputs/Filter.gd"
class_name BalanceFilter

func _init().():
    pass

func token_id(token_id: String) -> BalanceFilter:
    set_variable("tokenId", token_id)
    return self

func token_id_in(token_ids: Array) -> BalanceFilter:
    set_variable("tokenId_in", token_ids)
    return self

func wallet(wallet: String) -> BalanceFilter:
    set_variable("wallet", wallet)
    return self

func wallet_in(addresses: Array) -> BalanceFilter:
    set_variable("wallet_in", addresses)
    return self

func value(value: int) -> BalanceFilter:
    set_variable("value", value)
    return self

func value_gt(value: int) -> BalanceFilter:
    set_variable("value_gt", value)
    return self

func value_gte(value: int) -> BalanceFilter:
    set_variable("value_gte", value)
    return self

func value_lt(value: int) -> BalanceFilter:
    set_variable("value_lt", value)
    return self

func value_lte(value: int) -> BalanceFilter:
    set_variable("value_lte", value)
    return self

func and_filters(others: Array) -> BalanceFilter:
    .and_filters(others)
    return self

func or_filters(others: Array) -> BalanceFilter:
    .or_filters(others)
    return self
