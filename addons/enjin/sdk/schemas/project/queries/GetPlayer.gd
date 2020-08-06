extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name GetPlayer

const PlayerFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PlayerFragmentArguments.gd")

var player_fragment_args: PlayerFragmentArguments

func _init().("enjin.sdk.project.GetPlayer"):
    player_fragment_args = PlayerFragmentArguments.new(self)

func id(id: String) -> GetPlayer:
    set_variable("id", id)
    return self
