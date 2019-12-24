extends Node2D
signal update_hud

export var respawn_height = 1500

func _ready():
    respawn($Player)

func _process(delta):
    if $Player.position.y > respawn_height:
        $Player.health = max(0, $Player.health - 1)

        if $Player.health == 0:
            get_tree().reload_current_scene()
            return

        respawn($Player)
        emit_signal("update_hud", $Player)

func respawn(player):
    player.position.x = $Spawn.position.x
    player.position.y = $Spawn.position.y

func exit_entered(body):
    if $Player.coins == 3:
        print("can exit!")
    else:
        print("need more coins")