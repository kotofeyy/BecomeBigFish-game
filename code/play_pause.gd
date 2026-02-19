extends Node

@onready var pause_play_rect: TextureRect = $"../CanvasLayer/PausePlayRect"

const PAUSE = preload("uid://btl0jyqibtmtu")


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = !get_tree().paused 
		if get_tree().paused:
			pause_play_rect.texture = PAUSE
			pause_play_rect.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		else:
			pause_play_rect.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
