extends CanvasLayer

@onready var current_score_label: Label = $MarginContainer/VBoxContainer/CurrentScoreLabel

func pause_game(score: int) -> void:
	current_score_label.text = "Current score: " + str(score)
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("exit"):
		get_viewport().set_input_as_handled()
		_on_resume_pressed()

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")
