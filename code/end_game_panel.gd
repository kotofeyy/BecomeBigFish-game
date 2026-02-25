class_name EndGamePanel
extends Panel

@onready var count_of_fish_label: Label = $MarginContainer/VBoxContainer/CountOfFishLabel
@onready var all_scores_label: Label = $MarginContainer/VBoxContainer/AllScores
@onready var audio_end_game_score: AudioStreamPlayer = $AudioEndGameScore
@onready var restart_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/RestartButton
@onready var cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton



signal on_restart
signal on_cancel

var count_of_fish:
	set(value):
		count_of_fish = value

var score:
	set(value):
		score = value
		print("score in end panel - ", score)


func _ready() -> void:
	update_info()


func show_self() -> void:
	visible = !visible
	update_info()


func update_info() -> void:
	count_of_fish_label.text = tr("KEY_FISH_EATEN") + ": " + str(score)


func _on_restart_button_pressed() -> void:
	emit_signal("on_restart")


func _on_cancel_button_pressed() -> void:
	emit_signal("on_cancel")
