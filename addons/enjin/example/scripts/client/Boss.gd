extends KinematicBody2D
signal boss_defeated

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 250
export var gravity = 30
export var approach_distance = 150
export var retreat_distance = 100
export var attack_cooldown = 2

var is_fighting = false
var player
var facing_left = false
var velocity = Vector2(0, 0)
var moving = false
var attack_cooldown_remaining = 0
var mid_attack = false
var health = 3
var stunned = false

var _voice_1: AudioStream = preload("res://addons/enjin/example/audio/bull_1.wav")
var _voice_2: AudioStream = preload("res://addons/enjin/example/audio/bull_2.wav")
var _voice_3: AudioStream = preload("res://addons/enjin/example/audio/bull_3.wav")

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]
    _set_direction_and_movement(true, false)

func _process(delta):
    if health == 0:
        return

    var distance = get_global_position().distance_to(player.get_global_position())

    velocity.y += gravity
    attack_cooldown_remaining = max(0, attack_cooldown_remaining - delta)

    if stunned:
        return

    if !is_fighting:
        return

    var x_diff = get_global_position().x - player.get_global_position().x
    if !mid_attack:
        var to_left = x_diff > 0
        var move_away = abs(x_diff) < retreat_distance
        var move_towards = abs(x_diff) > approach_distance

        if move_towards:
            _set_direction_and_movement(to_left, true, to_left)
        elif move_away:
            _set_direction_and_movement(to_left, true, !to_left)
        else:
            _set_direction_and_movement(to_left, false)

    var left_bodies = $Chop/Left.get_overlapping_bodies()
    var right_bodies = $Chop/Right.get_overlapping_bodies()
    var can_attack = left_bodies.has(player) || right_bodies.has(player)

    if moving:
        $Sprite/AnimationPlayer.play("Run")
    elif can_attack && attack_cooldown_remaining <= 0:
        attack()
    elif !mid_attack:
        $Sprite/AnimationPlayer.play("Idle")

func attack():
    # Face the player
    var x_diff = get_global_position().x - player.get_global_position().x
    var to_left = x_diff > 0
    _set_direction_and_movement(to_left, false)

    $Sprite/AnimationPlayer.play("Chop")
    if $AttackSFX.playing:
        $AttackSFX.stop()
    $AttackSFX.play(0)
    attack_cooldown_remaining = attack_cooldown
    mid_attack = true

func _set_direction_and_movement(face_left = true, moving = true, move_left = true):
    if (facing_left != face_left):
        facing_left = face_left
        $Sprite.flip_h = facing_left

    var move_mod = -1 if move_left else 1

    self.moving = moving
    if moving:
        velocity = Vector2(speed * move_mod, velocity.y)
    else:
        velocity = Vector2(0, velocity.y)

func _physics_process(delta):
    velocity = move_and_slide(velocity, FLOOR)

func animation_complete(name):
    if name == "Chop":
        mid_attack = false
        $Sprite/AnimationPlayer.play("Idle")
    elif name == "Damage 1" or name == "Damage 2":
        $Sprite/AnimationPlayer.play("Taunt")
    elif name == "Taunt":
        $Sprite/AnimationPlayer.play("Idle")
        stunned = false
        $Bounce/CollisionShape2D.disabled = false

func chop_hit_check():
    if facing_left and $Chop/Left.overlaps_body(player):
        player.damage(1)
        _knockback_body(player)
    elif !facing_left and $Chop/Right.overlaps_body(player):
        player.damage(1)
        _knockback_body(player)

func player_bounced_on_head(entity):
    health = max(0, health - 1)

    if $DamageSFX.playing:
        $DamageSFX.stop()
    $DamageSFX.play(0)

    if $VoiceSFX.playing:
        $VoiceSFX.stop()

    if health == 0:
        velocity = Vector2.ZERO
        $Sprite/AnimationPlayer.play("Death")
        $Bounce/CollisionShape2D.disabled = true
        $HitZone/CollisionShape2D.disabled = true
        $VoiceSFX.stream = _voice_3 # Death sound
        $VoiceSFX.play(0)           #
        emit_signal("boss_defeated")
        return
    elif health == 1:
        $VoiceSFX.stream = _voice_2
        $VoiceSFX.play(0)
    else:
        $VoiceSFX.stream = _voice_1
        $VoiceSFX.play(0)

    $Sprite/AnimationPlayer.play("Damage 1" if health == 2 else "Damage 2")
    $Bounce/CollisionShape2D.disabled = true
    stunned = true
    velocity = Vector2(0, 0)

func _knockback_body(body):
    if body.knockbacked:
        return
    var x_diff = get_global_position().x - player.get_global_position().x

    body.knockback(x_diff < 0)

func _on_hitzone_entered(body):
    _knockback_body(body)
    if body == player:
        player.damage(1)
