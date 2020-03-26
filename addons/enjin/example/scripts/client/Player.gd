extends KinematicBody2D

enum Direction {
    LEFT,
    RIGHT
}

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 300 * 1.75
export var gravity = 30
export var jump_mod = 1.75
export var jump_cooldown = 0.08
export var climb_mod = 0.8
export var bounce_mod = -750
export var knockback_vec = Vector2(400, -300)

var velocity: Vector2 = Vector2(0, 0)
var facing = Direction.RIGHT
var coins_in_wallet = 0
var coins: int = 0
var max_health: int = 3
var health: int = 3
var jump_cooldown_remaining: float = 0
var climbing: bool = false
var has_key: bool = false
var has_crown: bool = false
var wallet
var accept_input = true
var knockbacked: bool = false
var landing_delay: float = 0.1
var landing_delay_remaining: float = 0

var king_texture = preload("res://addons/enjin/example/art/king/king.png")

func _physics_process(delta):
    if !$"../"._loaded:
        return

    check_bounce(delta)

    # x movement
    if accept_input:
        if Input.is_action_pressed("ui_right"):
            velocity.x = speed
            facing = Direction.RIGHT
        elif Input.is_action_pressed("ui_left"):
            velocity.x = -speed
            facing = Direction.LEFT
        else:
            velocity.x = 0
    elif knockbacked:
        velocity.x = lerp(velocity.x, 0, 0.005)
        if is_on_floor() and landing_delay_remaining == 0.0:
            accept_input = true
            knockbacked = false

    if landing_delay_remaining != 0.0:
        landing_delay_remaining = max(0, landing_delay_remaining - delta)

    # jump cooldown
    if is_on_floor() and jump_cooldown_remaining != 0.0:
        jump_cooldown_remaining = max(0, jump_cooldown_remaining - delta)

    if accept_input:
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
                velocity.y = -speed * jump_mod

    velocity.y += gravity

    # Set sprite animation to play
    if velocity.y != 0 and !is_on_floor():
        if velocity.y < 0 and !$Sprite/AnimationPlayer.current_animation == "Jump":
            $Sprite/AnimationPlayer.play("Jump")
        elif velocity.y > 0 and !$Sprite/AnimationPlayer.current_animation == "Fall":
            $Sprite/AnimationPlayer.play("Fall")
    elif velocity.x != 0:
        $Sprite/AnimationPlayer.play("Run")
    else:
        $Sprite/AnimationPlayer.play("Idle")

    # Flip sprite animation to face direction of movement
    if facing == Direction.LEFT:
        $Sprite.flip_h = true
    else:
        $Sprite.flip_h = false

    velocity = move_and_slide(velocity, FLOOR)

func add_coins(amount: int):
    coins += amount
    return coins

func damage(amount: int):
    health = max(0, health - amount)

    if is_dead():
        get_tree().reload_current_scene()

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

func health_upgrade_grabbed(body):
    max_health = 5
    health += 2

func check_bounce(delta):
    if velocity.y <= 0:
        return

    var rays = get_tree().get_nodes_in_group("bounce_ray")
    for ray in rays:
        ray.cast_to = Vector2.DOWN * velocity * delta + Vector2.DOWN
        ray.force_raycast_update()
        if ray.is_colliding() and ray.get_collision_normal() == Vector2.UP:
            if ray.get_collider().get_child(0).disabled or not ray.get_collider().is_in_group("bounce_box"):
                continue
            print("bouncing")
            velocity.y = bounce_mod
            ray.get_collider().call_deferred("bounced_on", self)

func knockback(move_right: bool):
    accept_input = false
    knockbacked = true
    landing_delay_remaining = landing_delay

    damage(1)

    if move_right:
        velocity = Vector2(knockback_vec.x, knockback_vec.y)
    else:
        velocity = Vector2(-knockback_vec.x, knockback_vec.y)
