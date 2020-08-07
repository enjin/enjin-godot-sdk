extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlayers

const PlayerFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PlayerFragmentArguments.gd")
const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")

var player_fragment_args: PlayerFragmentArguments
var pag_fragment_args: PaginationArguments

func _init().("enjin.sdk.project.GetPlayers"):
    player_fragment_args = PlayerFragmentArguments.new(self)
    pag_fragment_args = PaginationArguments.new(self)

func filter(filter: PlayerFilter) -> GetPlayers:
    set_variable("filter", filter.get_vars().duplicate())
    return self
