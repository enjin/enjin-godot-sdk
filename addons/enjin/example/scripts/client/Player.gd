extends KinematicBody2D
signal player_dead

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
var invulnerability_remaining: float = 0
var invulnerability_time: float = 1
var _was_in_air: bool = false

var king_texture = preload("res://addons/enjin/example/art/king/king.png")
var _climb_1_sfx: AudioStream = preload("res://addons/enjin/example/audio/ladder_1_sfx.wav")
var _climb_2_sfx: AudioStream = preload("res://addons/enjin/example/audio/ladder_2_sfx.wav")
var _coin_sfx: AudioStream = preload("res://addons/enjin/example/audio/coin_sfx.wav")
var _item_sfx: AudioStream = preload("res://addons/enjin/example/audio/item_pickup_sfx.wav")
var _land_sfx: AudioStream = preload("res://addons/enjin/example/audio/land.wav")
var _step_sfx_1: AudioStream = preload("res://addons/enjin/example/audio/player_step_1_sfx.wav")
var _step_sfx_2: AudioStream = preload("res://addons/enjin/example/audio/player_step_2_sfx.wav")

func _physics_process(delta):
    var run: bool = false
    var land: bool = false
    var climb: bool = false

    invulnerability_remaining = max(0, invulnerability_remaining - delta)

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
                climb = true
            elif Input.is_action_pressed("ui_down"):
                velocity.y = speed * climb_mod
                climb = true
            else:
                velocity.y = 0
        else:
            if Input.is_action_pressed("ui_up") and is_on_floor() and jump_cooldown_remaining == 0.0:
                jump_cooldown_remaining = jump_cooldown
                velocity.y = -speed * jump_mod

    if !climbing:
        velocity.y += gravity

    # Set sprite animation to play
    if velocity.y != 0 and !is_on_floor():
        if velocity.y < 0 and !$Sprite/AnimationPlayer.current_animation == "Jump":
            $Sprite/AnimationPlayer.play("Jump")
        elif velocity.y > 0 and !$Sprite/AnimationPlayer.current_animation == "Fall":
            $Sprite/AnimationPlayer.play("Fall")
    elif velocity.x != 0:
        $Sprite/AnimationPlayer.play("Run")
        run = true
    else:
        $Sprite/AnimationPlayer.play("Idle")

    # Flip sprite animation to face direction of movement
    if facing == Direction.LEFT:
        $Sprite.flip_h = true
    else:
        $Sprite.flip_h = false

    velocity = move_and_slide(velocity, FLOOR)

    if is_on_floor() and _was_in_air and !knockbacked:
        land = true

    _was_in_air = !is_on_floor()

    _movement_sfx(run, land, climb)

func add_coins(amount: int):
    if $PickupSFX.playing:
        $PickupSFX.stop()
    $PickupSFX.set_stream(_coin_sfx)
    $PickupSFX.play(0)
    coins += amount
    return coins

func damage(amount: int):
    if invulnerability_remaining > 0:
        return

    health = max(0, health - amount)

    if is_dead():
        hide()
        accept_input = false
        emit_signal("player_dead")
    else:
        invulnerability_remaining = invulnerability_time

func is_dead():
    return health == 0

func _ladder_entered(body):
    climbing = true

func _ladder_exited(body):
    climbing = false

func key_grabbed(body):
    _play_item_sfx()
    has_key = true

func swap_textures():
    $Sprite.set_texture(king_texture)

func crown_grabbed(body):
    _play_item_sfx()
    has_crown = true
    swap_textures()

func health_upgrade_grabbed(body):
    _play_item_sfx()
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
    if $DamageSFX.playing:
        $DamageSFX.stop()
    $DamageSFX.play(0)

    accept_input = false
    knockbacked = true
    landing_delay_remaining = landing_delay

    if move_right:
        velocity = Vector2(knockback_vec.x, knockback_vec.y)
    else:
        velocity = Vector2(-knockback_vec.x, knockback_vec.y)

func _play_item_sfx():
    if $PickupSFX.playing:
        $PickupSFX.stop()
    $PickupSFX.set_stream(_item_sfx)
    $PickupSFX.play(0)

func _movement_sfx(run: bool, land: bool, climb: bool):
    $GroundSFX.bus = "SFX"

    # Uses the climb sfx if running on ladders
    if run and climbing:
        run = false
        climb = true

    if land:
        $GroundSFX.stop()
        $GroundSFX.stream = _land_sfx
        $GroundSFX.play(0)
    elif run and !$GroundSFX.playing:
        # Alternates footsteps
        if $GroundSFX.stream != _step_sfx_1:
            $GroundSFX.stream = _step_sfx_1
        else:
            $GroundSFX.stream = _step_sfx_2
        $GroundSFX.play(0)
    elif climb:
        # Switches to climb SFX immediatly
        if $GroundSFX.stream != _climb_1_sfx:
            $GroundSFX.stop()
            $GroundSFX.set_stream(_climb_1_sfx)

        if !$GroundSFX.playing:
            var bus = AudioServer.get_bus_index("SFX Pitch Shift")
            var effect: AudioEffectPitchShift = AudioServer.get_bus_effect(bus, 0)
            effect.pitch_scale = rand_range(0.8, 1.2)

            $GroundSFX.bus = "SFX Pitch Shift"
            $GroundSFX.play(0)
