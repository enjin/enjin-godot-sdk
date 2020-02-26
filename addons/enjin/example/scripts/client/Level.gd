extends Node2D

# Nodes
onready var player = $"../Player"
onready var spawn = $Spawn

# Exports
export var respawn_height = 1500

func _ready():
    respawn()

func _process(delta):
    if player.position.y > respawn_height:
        out_of_bounds()

func out_of_bounds():
    player.damage(1)
    respawn()

func respawn():
    player.position.x = spawn.position.x
    player.position.y = spawn.position.y


func key_grabbed(body):
    $Key.queue_free()
