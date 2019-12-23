extends KinematicBody2D
signal update_hud

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 300
export var gravity = 30
export var jump_mod = 2.8
export var sprint_mod = 1.75
export var sprint_jump_mod = 0.35

var velocity: Vector2 = Vector2(0, 0)
var coins: int = 0

func _physics_process(delta):
    var moving = false
    var sprinting = Input.is_key_pressed(KEY_SHIFT)

    if Input.is_action_pressed("ui_right"):
        velocity.x = speed
        moving = true
    elif Input.is_action_pressed("ui_left"):
        velocity.x = -speed
        moving = true
    elif !is_on_floor():
        # Lerping the horizontal velocity to 0 when jumping/falling
        # to create a smoother transition
        velocity.x = lerp(velocity.x, 0, 0.025)
    else:
        velocity.x = 0

    if Input.is_action_pressed("ui_up") and is_on_floor():
        if sprinting:
            velocity.y = -speed * (jump_mod + sprint_jump_mod)
        else:
            velocity.y = -speed * jump_mod

    if moving and sprinting:
        velocity.x *= sprint_mod

    velocity.y += gravity

    # Set sprite animation to play
    if velocity.y != 0 and !is_on_floor():
        if velocity.y < 0 and !$AnimatedSprite.animation == "Jump":
            $AnimatedSprite.play("Jump")
        elif velocity.y > 0 and !$AnimatedSprite.animation == "Fall":
            $AnimatedSprite.play("Fall")
    elif velocity.x != 0:
        if sprinting:
            $AnimatedSprite.play("Run")
        else:
            $AnimatedSprite.play("Walk")
    else:
        $AnimatedSprite.play("Idle")

    # Flip sprite animation to face direction of movement
    if velocity.x != 0:
        $AnimatedSprite.flip_h = velocity.x < 0

    velocity = move_and_slide(velocity, FLOOR)

func add_coins(amount: int):
    coins += amount
    emit_signal("update_hud", self)