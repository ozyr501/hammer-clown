extends CharacterBody2D

const CHARACTER_ACCELERATION = 1200.0
const CHARACTER_MAX_SPEED = 1500.0
const CHARACTER_PASSIVE_DECELERATION = 4000.0

const THROW_STRENGTH = 0.40
const MAX_THROW_VELOCITY = 1400.0
const OVERREACH_MARGIN = 50.0

@onready var grab_area: Area2D = $Area2D
@onready var grab_area_shape: CollisionShape2D = $Area2D/CollisionShape2D

var held_body: JuggleableBody2D
var held_offset := Vector2.ZERO
var mouse_motion := Vector2.ZERO
var mouse_velocity := Vector2.ZERO

# overrides

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion += event.relative
		
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		grab()

func _physics_process(delta: float) -> void:
	movement(delta)
	hold_or_throw(delta)


# input

func grab() -> void:
	if is_instance_valid(held_body):
		return

	for body in grab_area.get_overlapping_bodies():
		if not body is JuggleableBody2D:
			continue

		held_body = body
		held_offset = body.global_position - global_position
		held_body.begin_hold()
		break


# physics process

func movement(delta: float) -> void:
	velocity += get_gravity() * delta
	var horizontal_input = Input.get_axis("move_left", "move_right")
	if velocity.x == 0 or sign(horizontal_input) == sign(velocity.x):
		velocity.x += horizontal_input * CHARACTER_ACCELERATION * delta
	else:
		var initial_velocity_sign = sign(velocity.x)
		velocity.x -= CHARACTER_PASSIVE_DECELERATION * delta * initial_velocity_sign
		if initial_velocity_sign != sign(velocity.x) and horizontal_input == 0:
			velocity.x = 0
		
	if abs(velocity.x) > CHARACTER_MAX_SPEED:
		velocity.x = CHARACTER_MAX_SPEED * sign(velocity.x)
		
	move_and_slide()

func hold_or_throw(delta: float) -> void:
	var arm_length = grab_area_shape.shape.radius

	mouse_velocity = mouse_motion / delta
	held_offset = (held_offset + mouse_motion * THROW_STRENGTH).limit_length(arm_length + OVERREACH_MARGIN)
	mouse_motion = Vector2.ZERO

	if not is_instance_valid(held_body):
		return


	held_body.set_hold_position(global_position + held_offset)

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		held_body.release((mouse_velocity * THROW_STRENGTH).limit_length(MAX_THROW_VELOCITY))
		print("thrown with velocity: ", mouse_velocity * THROW_STRENGTH)
		held_body = null
