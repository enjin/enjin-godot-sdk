extends "res://addons/enjin/sdk/inputs/Filter.gd"
class_name AssetFilter

func _init().():
    pass

func id(id: String) -> AssetFilter:
    set_variable("id", id)
    return self

func id_in(ids: Array) -> AssetFilter:
    set_variable("id_in", ids)
    return self

func name(name: String) -> AssetFilter:
    set_variable("name", name)
    return self

func name_contains(text: String) -> AssetFilter:
    set_variable("name_contains", text)
    return self

func name_in(names: Array) -> AssetFilter:
    set_variable("name_in", names)
    return self

func name_starts_with(prefix: String) -> AssetFilter:
    set_variable("name_starts_with", prefix)
    return self

func name_ends_with(suffix: String) -> AssetFilter:
    set_variable("name_ends_with", suffix)
    return self

func wallet(wallet: String) -> AssetFilter:
    set_variable("wallet", wallet)
    return self

func wallet_in(addresses: Array) -> AssetFilter:
    set_variable("wallet_in", addresses)
    return self

func and_filters(others: Array) -> AssetFilter:
    .and_filters(others)
    return self

func or_filters(others: Array) -> AssetFilter:
    .or_filters(others)
    return self
