extends Node2D

@onready var scoring_area: Area2D = $ScoringArea
@onready var label: Label = $UI/MarginContainer/ScoreLabel

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var final_score_label: Label = $GameOverScreen/MarginContainer/VBoxContainer/FinalScoreLabel

@onready var main_character: CharacterBody2D = $MainCharacter

var score : int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	PhysicsServer2D.set_active(true)
	


func _on_scoring_area_body_entered(body: Node2D) -> void:
	if body is JuggleableBody2D and body.was_thrown:
		score += 1
		label.text = "Score: " + str(score)

func _on_losing_area_body_entered(body: Node2D) -> void:
	PhysicsServer2D.set_active(false)
	main_character.process_mode = Node.PROCESS_MODE_DISABLED

	final_score_label.text = "Final score: " + str(score)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	game_over_screen.visible = true


func _on_retry_pressed() -> void:
	PhysicsServer2D.set_active(true)
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	PhysicsServer2D.set_active(true)
	get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")
