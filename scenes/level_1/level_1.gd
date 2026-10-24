extends Node2D

@onready var scoring_area: Area2D = $ScoringArea
@onready var label: Label = $CanvasLayer/MarginContainer/Label

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
	


func _on_scoring_area_body_entered(body: Node2D) -> void:
	if body is JuggleableBody2D and body.was_thrown:
		score += 1
		label.text = "Score: " + str(score)

func _on_loosing_area_body_entered(body: Node2D) -> void:
	pass

func _on_losing_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
