extends CharacterBody2D

const CHARACTER_ACCELERATION = 600.0
const CHARACTER_MAX_SPEED = 300.0
const CHARACTER_PASSIVE_DECELERATION = 1000.0

func _physics_process(delta: float) -> void:
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
