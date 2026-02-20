class_name EndGamePanel
extends Panel

@onready var count_of_fish_label: Label = $MarginContainer/VBoxContainer/CountOfFishLabel
@onready var all_scores_label: Label = $MarginContainer/VBoxContainer/AllScores
@onready var audio_end_game_score: AudioStreamPlayer = $AudioEndGameScore


signal on_restart
signal on_cancel
signal update_scores

var count_of_fish:
	set(value):
		count_of_fish = value

var all_scores:
	set(value):
		all_scores = value

var score:
	set(value):
		score = value


func show_self() -> void:
	visible = !visible
	update_info()


func update_info() -> void:
	count_of_fish_label.text = tr("KEY_FISH_EATEN") + ": " + str(score)
	all_scores_label.text = tr("KEY_SCORE") + ": " + str(all_scores)
	
	if score > 0:
		var temp_score = score
		var temp_all_scores = all_scores
		all_scores = all_scores + temp_score
		score = score - score
		await get_tree().create_timer(1).timeout
		audio_end_game_score.play()
		animate_count_of_fish(temp_score, score)
		animate_all_score_label(temp_all_scores, all_scores)
		


func _on_restart_button_pressed() -> void:
	emit_signal("on_restart")


func _on_cancel_button_pressed() -> void:
	emit_signal("on_cancel")


func animate_count_of_fish(start_val: int, end_val: int, duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_method(_set_label_fish_eat, start_val, end_val, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)


func _set_label_fish_eat(value: int):
	count_of_fish_label.text = tr("KEY_FISH_EATEN") + ": " + str(value)


func animate_all_score_label(start_val: int, end_val: int, duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_method(_set_label_all_scores, start_val, end_val, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): 
		emit_signal("update_scores", all_scores)
		)


func _set_label_all_scores(value: int):
	all_scores_label.text = tr("KEY_SCORE") + ": " + str(value)
