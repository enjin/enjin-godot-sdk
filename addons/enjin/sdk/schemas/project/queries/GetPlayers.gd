extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlayers

const PlayerFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PlayerFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var player_i: PlayerFragmentArguments
var pagination_i: PaginationArguments

func _init().("enjin.sdk.project.GetPlayers"):
    player_i = PlayerFragmentArguments.new(self)
    pagination_i = PaginationArguments.new(self)

func filter(filter: PlayerFilter) -> GetPlayers:
    set_variable("filter", filter.get_vars().duplicate())
    return self
