class_name JuggleableBody2D
extends RigidBody2D

@onready var arrow: Sprite2D = $Arrow

const TERMINAL_VELOCITY = 1000.0

var _is_held := false
var _held_transform := Transform2D.IDENTITY
var _release_requested := false
var _release_velocity := Vector2.ZERO

var was_thrown := false

func _process(_delta: float) -> void:
	if global_position.y < 0:
		arrow.visible = true
		arrow.global_position = Vector2(global_position.x, 24.0)
		arrow.global_rotation = 0.0
	else:
		arrow.visible = false


func _physics_process(delta: float) -> void:
	if linear_velocity.y > TERMINAL_VELOCITY:
		linear_velocity.y = TERMINAL_VELOCITY

func begin_hold() -> void:
	_held_transform = global_transform
	_is_held = true
	_release_requested = false
	custom_integrator = true
	can_sleep = false
	sleeping = false

func set_hold_position(target_position: Vector2) -> void:
	_held_transform.origin = target_position

func release(throw_velocity: Vector2) -> void:
	_release_velocity = throw_velocity
	_release_requested = true
	was_thrown = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not _is_held:
		return

	state.transform = _held_transform
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0.0

	if _release_requested:
		state.linear_velocity = _release_velocity
		state.angular_velocity = randf_range(-10.0, 10.0)
		_is_held = false
		_release_requested = false
		custom_integrator = false
		can_sleep = true
