extends KinematicBody2D

func _process(delta):
    if Input.is_action_pressed("ui_left") and scale.x > 0:
        scale.x *= -1
    elif Input.is_action_pressed("ui_right") and scale.x < 0:
        scale.x *= -1
