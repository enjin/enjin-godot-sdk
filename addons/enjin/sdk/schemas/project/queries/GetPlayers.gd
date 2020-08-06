extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlayers

const PaginationArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PaginationArguments.gd")
const PlayerFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PlayerFragmentArguments.gd")

var pag_fragment_args: PaginationArguments
var player_fragment_args: PlayerFragmentArguments

func _init().("enjin.sdk.project.GetPlayers"):
    pag_fragment_args = PaginationArguments.new(self)
    player_fragment_args = PlayerFragmentArguments.new(self)

func filter(filter: Object) -> GetPlayers:
    set_variable("filter", filter)
    return self
