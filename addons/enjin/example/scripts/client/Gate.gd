extends Sprite

func player_entered_gate(body):
    if body.has_key:
        queue_free()
