extends KinematicBody2D

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 100
export var gravity = 30
export var player_detect_distance = 250
export var attack_cooldown = 2

onready var ray = $LeftGroundRay
onready var attack_area = $AttackLeft

var player
var velocity = Vector2(-speed, 0)
var moving_left = true;
var attack_cooldown_remaining = 0

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
    var distance = get_global_position().distance_to(player.get_global_position())
    var x_diff = get_global_position().x - player.get_global_position().x
    var can_move = ray.is_colliding()

    velocity.y += gravity
    attack_cooldown_remaining = max(0, attack_cooldown_remaining - delta)

    if distance < player_detect_distance:
        var is_attacking = attack_area.overlaps_body(player)
        var face_left = x_diff > 0

        if is_attacking:
            _set_direction_and_movement(face_left, false)
            if attack_cooldown_remaining == 0:
                $AnimatedSprite.play("attack")
        elif can_move:
            if $AnimatedSprite.animation != "attack":
                _set_direction_and_movement(face_left, true)
                $AnimatedSprite.play("move")
        else:
            _set_direction_and_movement(face_left, false)
            if $AnimatedSprite.animation == "move":
                $AnimatedSprite.play("idle")
    elif can_move:
        _set_direction_and_movement(moving_left)
    else:
        _set_direction_and_movement(!moving_left)

func _set_direction_and_movement(facing_left = true, moving = true):
    if (facing_left != moving_left):
        moving_left = facing_left
        $AnimatedSprite.flip_h = !moving_left
        ray = $LeftGroundRay if moving_left else $RightGroundRay
        attack_area = $AttackLeft if moving_left else $AttackRight

    if moving:
        velocity = Vector2(-speed if facing_left else speed, velocity.y)
    else:
        velocity = Vector2(0, velocity.y)

func _physics_process(delta):
    velocity = move_and_slide(velocity, FLOOR)

func _animation_complete():
    if $AnimatedSprite.animation == "attack":
        var can_attack = attack_area.overlaps_body(player)
        var can_move = ray.is_colliding()
        if can_attack:
            $AnimatedSprite.play("idle")
        elif can_move:
            $AnimatedSprite.play("move")

func _on_frame_change():
    var is_attack_anim = $AnimatedSprite.animation == "attack"
    var is_hit_frame = $AnimatedSprite.frame == 2
    if is_attack_anim and is_hit_frame and attack_area.overlaps_body(player):
        player.damage(1)
