extends Parallax2D

func _ready() -> void:
	autoscroll = random_velocity()
	change_direction()

func random_velocity() -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(-PI, PI)) * 20.0

func change_direction() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "autoscroll", random_velocity(), 20.0)
	tween.finished.connect(change_direction)
