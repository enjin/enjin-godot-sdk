extends "res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd"
class_name PlayerGetPlayer

const PlayerFragmentArguments = preload("res://addons/enjin/sdk/schemas/shared/arguments/PlayerFragmentArguments.gd")

var player_i: PlayerFragmentArguments

func _init().("enjin.sdk.player.GetPlayer"):
    player_i = PlayerFragmentArguments.new(self)
