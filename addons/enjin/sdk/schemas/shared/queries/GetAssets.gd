extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetAssets

const AssetFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/AssetFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var asset_i: AssetFragmentArguments
var pagination_i: PaginationArguments

func _init().("enjin.sdk.shared.GetAssets"):
    asset_i = AssetFragmentArguments.new(self)
    pagination_i = PaginationArguments.new(self)

func filter(filter: AssetFilter) -> GetAssets:
    return set_variable("filter", filter.get_vars().duplicate())

func sort(sort: AssetSort) -> GetAssets:
    return set_variable("sort", sort.get_vars().duplicate())
