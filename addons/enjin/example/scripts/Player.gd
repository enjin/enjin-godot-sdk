extends RigidBody2D

const Direction = {
    ZERO = Vector2(0, 0),
    LEFT = Vector2(-1, 0),
    RIGHT = Vector2(1, 0),
    UP = Vector2(0, -1),
    DOWN = Vector2(0, 1)
}

export var acceleration = 10000
export var walk_max = 400
export var jump_max = 1000
export var jump_min = 500
export var fall_max = 1000

var directional_force = Direction.ZERO
var last_horizontal_dir = Direction.RIGHT
var last_vertical_dir = Direction.DOWN
var on_ground = false

func _process(delta):
    var velocity = get_linear_velocity()

    if on_ground and directional_force.y < 0:
        on_ground = false
    elif not on_ground and velocity.y == 0:
        on_ground = true

    if velocity.length() > 0:
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    if velocity.x != 0:
        $AnimatedSprite.animation = "Walk"
    else:
        $AnimatedSprite.animation = "Idle"

    $AnimatedSprite.flip_h = last_horizontal_dir.x < 0

    if velocity.y < 0:
        last_vertical_dir = Direction.UP
    elif velocity.y > 0:
        last_vertical_dir = Direction.DOWN

    if velocity.x < 0:
        last_horizontal_dir = Direction.LEFT
    elif velocity.x > 0:
        last_horizontal_dir = Direction.RIGHT

func _integrate_forces(state):
    var final_force = Vector2()

    directional_force = Direction.ZERO

    get_input(state)

    final_force = state.get_linear_velocity() + (directional_force * acceleration)
    final_force.x = clamp(final_force.x, -walk_max, walk_max)
    final_force.y = clamp(final_force.y, -jump_max, fall_max)

    if Input.is_action_just_released("ui_up") and final_force.y < -jump_min:
        final_force.y = -jump_min

    state.set_linear_velocity(final_force)

func get_input(state):
    directional_force.x = 0

    # apply horizontal force
    if Input.is_action_pressed("ui_right"):
        directional_force += Direction.RIGHT
    if Input.is_action_pressed("ui_left"):
        directional_force += Direction.LEFT

    # apply vertical force
    if on_ground and Input.is_action_pressed("ui_up"):
        directional_force += Direction.UP