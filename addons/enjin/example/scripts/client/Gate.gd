extends Sprite

func _ready():
    pass


func player_entered_gate(body):
    if body.has_key:
        queue_free()
