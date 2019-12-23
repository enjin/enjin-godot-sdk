extends Area2D

export var amount = 1

func on_collision(body: Node):
    if body.is_in_group("player"):
        body.add_coins(amount)
        queue_free()
