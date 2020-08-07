extends "res://addons/enjin/sdk/inputs/Filter.gd"
class_name TokenFilter

func _init().():
    pass

func id(id: String) -> TokenFilter:
    set_variable("id", id)
    return self

func id_in(ids: Array) -> TokenFilter:
    set_variable("id_in", ids)
    return self

func name(name: String) -> TokenFilter:
    set_variable("name", name)
    return self

func name_contains(text: String) -> TokenFilter:
    set_variable("name_contains", text)
    return self

func name_in(names: Array) -> TokenFilter:
    set_variable("name_in", names)
    return self

func name_starts_with(prefix: String) -> TokenFilter:
    set_variable("name_starts_with", prefix)
    return self

func name_ends_with(suffix: String) -> TokenFilter:
    set_variable("name_ends_with", suffix)
    return self

func wallet(wallet: String) -> TokenFilter:
    set_variable("wallet", wallet)
    return self

func wallet_in(addresses: Array) -> TokenFilter:
    set_variable("wallet_in", addresses)
    return self

func and_filters(others: Array) -> TokenFilter:
    .and_filters(others)
    return self

func or_filters(others: Array) -> TokenFilter:
    .or_filters(others)
    return self
