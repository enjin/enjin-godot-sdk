extends KinematicBody2D

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 100
export var gravity = 30
export var player_distance_threshold = 100
export var attack_cooldown = 2

onready var player = $"../../../Player"
onready var ray = $LeftGroundRay

var velocity = Vector2(-speed, 0)
var moving_left = true;
var attack_cooldown_remaining = 0

func _process(delta):
    var distance = get_global_position().distance_to(player.get_global_position())
    var x_diff = get_global_position().x - player.get_global_position().x

    velocity.y += gravity

    attack_cooldown_remaining = max(0, attack_cooldown_remaining - delta)

    if distance < player_distance_threshold:
        _set_moving_and_direction(x_diff > 0, false)
        if attack_cooldown_remaining == 0:
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
    if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == 2:
        player.damage(1)
