extends Control

@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var instructions: PanelContainer = $Instructions
@onready var fog: Parallax2D = $Background/FogParalax

func _ready() -> void:
	instructions.hide()
	fog.autoscroll = random_fog_velocity()
	change_fog_direction()

func random_fog_velocity() -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(-PI, PI)) * 20.0

func change_fog_direction() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(fog, "autoscroll", random_fog_velocity(), 20.0)
	tween.finished.connect(change_fog_direction)

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1/Level1.tscn")

func _on_instructions_pressed() -> void:
	menu_buttons.hide()
	instructions.show()

func _on_back_pressed() -> void:
	instructions.hide()
	menu_buttons.show()

func _on_exit_pressed() -> void:
	get_tree().quit(0)
