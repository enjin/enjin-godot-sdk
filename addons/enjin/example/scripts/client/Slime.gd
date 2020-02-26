extends KinematicBody2D

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 100
export var gravity = 30
export var player_detect_distance = 200
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

    velocity.y += gravity

    attack_cooldown_remaining = max(0, attack_cooldown_remaining - delta)

    if distance < player_detect_distance:
        var attack = attack_area.overlaps_body(player)
        _set_moving_and_direction(x_diff > 0, !attack)
        if attack and attack_cooldown_remaining == 0:
            $AnimatedSprite.set_animation("attack")
            attack_cooldown_remaining = attack_cooldown
    elif !ray.is_colliding():
        _set_moving_and_direction(!moving_left)
    else:
        _set_moving_and_direction(moving_left)

func _set_moving_and_direction(facing_left = true, moving = true):
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
        $AnimatedSprite.set_animation("idle")


func _on_frame_change():
    var is_attack_anim = $AnimatedSprite.animation == "attack"
    var is_hit_frame = $AnimatedSprite.frame == 2
    if is_attack_anim and is_hit_frame and attack_area.overlaps_body(player):
        player.damage(1)
