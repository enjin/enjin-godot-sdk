extends KinematicBody2D
signal boss_defeated

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 250
export var gravity = 30
export var approach_distance = 150
export var retreat_distance = 100
export var attack_cooldown = 2
export var invincibility_cooldown = 5

var is_fighting = false
var player
var facing_left = false
var velocity = Vector2(0, 0)
var moving = false
var attack_cooldown_remaining = 0
var invincibility_cooldown_remaining = 0
var mid_attack = false
var health = 3
var stunned = false

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]
    _set_direction_and_movement(true, false)

func _process(delta):
    if health == 0:
        return

    var distance = get_global_position().distance_to(player.get_global_position())

    velocity.y += gravity
    attack_cooldown_remaining = max(0, attack_cooldown_remaining - delta)
    invincibility_cooldown_remaining = max(0, invincibility_cooldown_remaining - delta)

    if stunned:
        return

    if invincibility_cooldown_remaining == 0 and $Bounce/CollisionShape2D.disabled:
        $Bounce/CollisionShape2D.disabled = false

    if !is_fighting:
        return

    var x_diff = get_global_position().x - player.get_global_position().x
    if !mid_attack:
        var to_left = x_diff > 0
        var move_away = distance < retreat_distance
        var move_towards = distance > approach_distance

        if move_towards:
            _set_direction_and_movement(to_left, true, to_left)
        elif move_away:
            _set_direction_and_movement(to_left, true, !to_left)
        else:
            _set_direction_and_movement(to_left, false)

    if moving:
        $Sprite/AnimationPlayer.play("Run")
    else:
        attack()

func attack():
    if attack_cooldown_remaining == 0:
        $Sprite/AnimationPlayer.play("Chop")
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

func chop_hit_check():
    if facing_left and $Chop/Left.overlaps_body(player):
        player.damage(1)
    elif !facing_left and $Chop/Right.overlaps_body(player):
        player.damage(1)

func player_bounced_on_head(entity):
    health = max(0, health - 1)
    if health == 0:
        velocity = Vector2.ZERO
        $Sprite/AnimationPlayer.play("Death")
        $Bounce/CollisionShape2D.disabled = true
        $HitZone/CollisionShape2D.disabled = true
        emit_signal("boss_defeated")
        return

    $Sprite/AnimationPlayer.play("Damage 1" if health == 2 else "Damage 2")
    $Bounce/CollisionShape2D.disabled = true
    invincibility_cooldown_remaining = invincibility_cooldown
    stunned = true
    velocity = Vector2(0, 0)


func _on_hitzone_entered(body):
    if body.knockbacked:
        return
    var x_diff = get_global_position().x - player.get_global_position().x

    body.knockback(x_diff < 0)
