extends Node2D

# Nodes
onready var player = $"../Player"
onready var spawn = $Spawn
# Exports
export var respawn_height = 2000

var boss_gate_body

func _ready():
    boss_gate_body = $Gate3/StaticBody2D
    $Gate3.hide()
    $Gate3.remove_child(boss_gate_body)
    respawn()

func start_boss_fight(body):
    $BossFightTrigger.queue_free()
    $Gate3.show()
    $Gate3.call_deferred("add_child", boss_gate_body)
    $Enemies/Boss.is_fighting = true

func finish_boss_fight():
    $Gate2.queue_free()

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

func crown_grabbed(body):
    $Crown.queue_free()

func health_upgrade_grabbed(body):
    $HealthUpgrade.queue_free()
