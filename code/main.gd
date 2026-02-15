extends Control

@onready var player: Sprite2D = $Player
@onready var audio_eat: AudioStreamPlayer = $AudioEat
@onready var fish_preload = preload("res://scenes/fish.tscn")
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/VBoxContainer/ProgressBar
@onready var level_label: Label = $CanvasLayer/Panel/VBoxContainer/LevelLabel


var has_game_started := false
var player_scale
var score = 0
var level = 1

func _ready() -> void:
	level_label.text = "Уровень " + str(level)
	progress_bar.max_value = level * 10
	player_scale = Util.size_to_scale[level - 1]
	player.scale = player_scale
	for i in 15:
		var fish: Fish = fish_preload.instantiate()
		add_child(fish)
		await get_tree().create_timer(0.3).timeout



func _process(delta: float) -> void:
	if progress_bar.ratio == 1.0:
		if level < 5:
			progress_bar.value = 0
			level += 1
			player_scale = Util.size_to_scale[level - 1]
			player.scale = player_scale
			
			progress_bar.min_value = score
			progress_bar.max_value = level * 10
			level_label.text = "Уровень " + str(level)


func _unhandled_input(event: InputEvent) -> void:
	player.global_position = get_global_mouse_position() 
	var mouse_velocity = Input.get_last_mouse_velocity()
	
	if mouse_velocity.x > 0:
		player.flip_h = true
	elif mouse_velocity.x < 0:
		player.flip_h = false


func on_eat_fish() -> void:
	audio_eat.play()
	score += 1
	update_progress()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if level - 1 >= area.get_parent().level:
		area.get_parent().reset_spawn()
		on_eat_fish()
	

func update_progress() -> void:
	progress_bar.value = score
