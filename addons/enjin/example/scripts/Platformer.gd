extends Node2D

export var respawn_height = 1500

func _ready():
    respawn($Player)

func _process(delta):
    if $Player.position.y > respawn_height:
        respawn($Player)

func respawn(player):
    player.position.x = $Spawn.position.x
    player.position.y = $Spawn.position.y