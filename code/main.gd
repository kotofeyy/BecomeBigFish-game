extends Control

@onready var player: Sprite2D = $Player
@onready var audio_eat: AudioStreamPlayer = $AudioEat
@onready var audio_level_up: AudioStreamPlayer = $AudioLevelUp
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

@onready var fish_preload = preload("res://scenes/fish.tscn")
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ProgressBar
@onready var level_label: Label = $CanvasLayer/Panel/MarginContainer/VBoxContainer/LevelLabel
@onready var animated_sprite_eat: AnimatedSprite2D = $AnimatedSpriteEat


var has_game_started := false
var player_scale
var score = 0
var level = 1

func _ready() -> void:
	chage_texture(level - 1)
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
		
		progress_bar.value = 0
		level += 1
		cpu_particles_2d.restart()
		if level < 5:
			player_scale = Util.size_to_scale[level - 1]
			player.scale = player_scale
		chage_texture(level - 1)
		audio_level_up.play()
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


func on_eat_fish(pos) -> void:
	audio_eat.play()
	animated_sprite_eat.global_position = pos
	animated_sprite_eat.play("eat")
	score += 1
	update_progress()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if level - 1 >= parent.level:
		on_eat_fish(parent.position)
		parent.reset_spawn()
		
	

func update_progress() -> void:
	progress_bar.value = score


func chage_texture(index: int) -> void:
	var tile_size = 16
	var x = (index % 3) * tile_size
	var y = (index / 3) * tile_size
	
	player.region_rect = Rect2(x, y, tile_size, tile_size)
