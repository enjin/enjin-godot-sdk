extends KinematicBody2D

const FLOOR: Vector2 = Vector2(0, -1)

export var speed = 250
export var gravity = 30
export var approach_distance = 150

var is_fighting = false
var player
var facing_left = true
var velocity = Vector2(0, 0)
var moving = false

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
    var distance = get_global_position().distance_to(player.get_global_position())

    velocity.y += gravity

    if !is_fighting:
        return

    var x_diff = get_global_position().x - player.get_global_position().x
    _set_direction_and_movement(x_diff > 0, distance > approach_distance)

    if moving:
        $Sprite/AnimationPlayer.play("Run")
    else:
        $Sprite/AnimationPlayer.play("Idle")

func _set_direction_and_movement(face_left = true, moving = true):
    if (facing_left != face_left):
        facing_left = face_left
        $Sprite.flip_h = facing_left

    self.moving = moving
    if moving:
        velocity = Vector2(-speed if facing_left else speed, velocity.y)
    else:
        velocity = Vector2(0, velocity.y)

func _physics_process(delta):
    velocity = move_and_slide(velocity, FLOOR)
