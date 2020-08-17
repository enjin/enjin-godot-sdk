extends "res://addons/enjin/sdk/inputs/Filter.gd"
class_name TransactionFilter

func _init().():
    pass

func id(id: String) -> TransactionFilter:
    set_variable("id", id)
    return self

func id_in(ids: Array) -> TransactionFilter:
    set_variable("id_in", ids)
    return self

func transaction_id(transaction_id: String) -> TransactionFilter:
    set_variable("transactionId", transaction_id)
    return self

func transaction_id_in(transaction_ids: Array) -> TransactionFilter:
    set_variable("transactionId_in", transaction_ids)
    return self

func token_id(token_id: String) -> TransactionFilter:
    set_variable("tokenId", token_id)
    return self

func token_id_in(token_ids: Array) -> TransactionFilter:
    set_variable("tokenId_in", token_ids)
    return self

func type(type: String) -> TransactionFilter:
    set_variable("type", type)
    return self

func type_in(types: Array) -> TransactionFilter:
    set_variable("type_in", types)
    return self

func value(value: int) -> TransactionFilter:
    set_variable("value", value)
    return self

func value_gt(value: int) -> TransactionFilter:
    set_variable("value_gt", value)
    return self

func value_gte(value: int) -> TransactionFilter:
    set_variable("value_gte", value)
    return self

func value_lt(value: int) -> TransactionFilter:
    set_variable("value_lt", value)
    return self

func value_lte(value: int) -> TransactionFilter:
    set_variable("value_lte", value)
    return self

func state(state: String) -> TransactionFilter:
    set_variable("state", state)
    return self

func state_in(states: Array) -> TransactionFilter:
    set_variable("state_in", states)
    return self

func wallet(wallet: String) -> TransactionFilter:
    set_variable("wallet", wallet)
    return self

func wallet_in(addresses: Array) -> TransactionFilter:
    set_variable("wallet_in", addresses)
    return self

func and_filters(others: Array) -> TransactionFilter:
    .and_filters(others)
    return self

func or_filters(others: Array) -> TransactionFilter:
    .or_filters(others)
    return self
