extends KinematicBody2D
signal update_hud

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 300
export var gravity = 30
export var jump_mod = 2.8
export var sprint_mod = 1.75
export var sprint_jump_mod = 0.35
export var jump_cooldown = 0.08
export var climb_mod = 0.8

var velocity: Vector2 = Vector2(0, 0)
var coins: int = 0
var health: int = 3
var jump_cooldown_remaining: float = 0
var climbing: bool = false
var has_key: bool = false
var has_crown: bool = false
var wallet

var king_texture = preload("res://addons/enjin/example/art/king/king.png")

func _physics_process(delta):
    var moving = false
    var sprinting = Input.is_key_pressed(KEY_SHIFT)

    # x movement
    if Input.is_action_pressed("ui_right"):
        velocity.x = speed
        moving = true
    elif Input.is_action_pressed("ui_left"):
        velocity.x = -speed
        moving = true
    elif !is_on_floor() and !climbing:
        # Lerping the horizontal velocity to 0 when jumping/falling
        # to create a smoother transition
        velocity.x = lerp(velocity.x, 0, 0.025)
    else:
        velocity.x = 0

    if moving and sprinting:
        velocity.x *= sprint_mod

    # jump cooldown
    if is_on_floor() and jump_cooldown_remaining != 0.0:
        jump_cooldown_remaining = max(0, jump_cooldown_remaining - delta)


    if climbing:
        if Input.is_action_pressed("ui_up"):
            velocity.y = -speed * climb_mod
        elif Input.is_action_pressed("ui_down"):
            velocity.y = speed * climb_mod
        else:
            velocity.y = 0
    else:
        if Input.is_action_pressed("ui_up") and is_on_floor() and jump_cooldown_remaining == 0.0:
            jump_cooldown_remaining = jump_cooldown

            if sprinting:
                velocity.y = -speed * (jump_mod + sprint_jump_mod)
            else:
                velocity.y = -speed * jump_mod

        velocity.y += gravity

    # Set sprite animation to play
    if velocity.y != 0 and !is_on_floor():
        if velocity.y < 0 and !$Sprite/AnimationPlayer.current_animation == "Jump":
            $Sprite/AnimationPlayer.play("Jump")
        elif velocity.y > 0 and !$Sprite/AnimationPlayer.current_animation == "Fall":
            $Sprite/AnimationPlayer.play("Fall")
    elif velocity.x != 0:
        if sprinting:
            $Sprite/AnimationPlayer.play("Run")
        else:
            $Sprite/AnimationPlayer.play("Walk")
    else:
        $Sprite/AnimationPlayer.play("Idle")

    # Flip sprite animation to face direction of movement
    if velocity.x != 0:
        $Sprite.flip_h = velocity.x < 0

    velocity = move_and_slide(velocity, FLOOR)

func add_coins(amount: int):
    coins += amount
    emit_signal("update_hud", self)
    return coins

func damage(amount: int) -> bool:
    health = max(0, health - amount)
    emit_signal("update_hud", self)

    if is_dead():
        get_tree().reload_current_scene()

    return health == 0

func is_dead():
    return health == 0

func _ladder_entered(body):
    climbing = true

func _ladder_exited(body):
    climbing = false

func key_grabbed(body):
    has_key = true

func swap_textures():
    $Sprite.set_texture(king_texture)

func crown_grabbed(body):
    has_crown = true
    swap_textures()
