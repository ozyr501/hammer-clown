extends AnimatableBody2D

signal score_bonus_points

var speed := 0.0
var screen_width := 0.0
var half_width := 0.0

@onready var nail_sprite: Sprite2D = $NailSprite
@onready var nail_area: Area2D = $NailArea
@onready var hammer_sound: AudioStreamPlayer = $HammerSound

func _ready() -> void:
	sync_to_physics = false
	screen_width = get_viewport_rect().size.x
	half_width = maxf($CartSprite.get_rect().size.x / 2.0, 98.0)
	speed = randf_range(200.0, 400.0)

	if randi_range(0, 1) == 0:
		position = Vector2(-half_width, 995.0)
	else:
		position = Vector2(screen_width + half_width, 995.0)
		speed = -speed

	sync_to_physics = true

func _physics_process(delta: float) -> void:
	position.x += speed * delta

	if speed > 0.0 and position.x > screen_width + half_width:
		queue_free()
	elif speed < 0.0 and position.x < -half_width:
		queue_free()


func _on_nail_area_body_entered(body: Node2D) -> void:
	if not body is JuggleableBody2D:
		return

	nail_sprite.position = Vector2(0.0, -12.0)
	nail_area.set_deferred("monitoring", false)
	score_bonus_points.emit()
	hammer_sound.play()
