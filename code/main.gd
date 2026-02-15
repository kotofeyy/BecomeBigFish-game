extends Control

@onready var player: Sprite2D = $Player
@onready var fishes: Node2D = $Fishes
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
var max_value_of_progress_bar = 10

func _ready() -> void:
	start_game()
	

func start_game() -> void:
	score = 0
	level = 1
	
	chage_texture(level - 1)
	progress_bar.max_value = level * 10
	player_scale = Util.size_to_scale[level - 1]
	player.scale = player_scale
	clear_fishes()
	spawn_fishes()
	level_label.text = "Уровень " + str(level)


func clear_fishes() -> void:
	var children = fishes.get_children()
	for fish in children:
		fish.queue_free()


func spawn_fishes() -> void:
	for i in 15:
		var fish: Fish = fish_preload.instantiate()
		fish.level = level
		fishes.add_child(fish)
		await get_tree().create_timer(0.3).timeout


func fish_level_update() -> void:
	var children = fishes.get_children()
	for fish: Fish in children:
		fish.level = level
		fish.reset_spawn()


func _process(delta: float) -> void:
	if progress_bar.ratio == 1.0:
		progress_bar.value = 0
		level_up()
		clear_fishes()
		spawn_fishes()
		progress_bar.min_value = score
		max_value_of_progress_bar = max_value_of_progress_bar * 1.4
		print("max value of progress bar - ", max_value_of_progress_bar)
		progress_bar.max_value = level * max_value_of_progress_bar
	# добавил немного вязкозти, для ощущения под водой
	var weight = 0.1
	player.global_position = player.global_position.lerp(get_global_mouse_position(), weight)



func _unhandled_input(event: InputEvent) -> void:
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
	if player_scale >= parent.fish_scale:
		on_eat_fish(parent.position)
		parent.reset_spawn()
		
	

func update_progress() -> void:
	progress_bar.value = score


func chage_texture(index: int) -> void:
	var tile_size = 16
	var x = (index % 3) * tile_size
	var y = (index / 3) * tile_size
	
	player.region_rect = Rect2(x, y, tile_size, tile_size)


func level_up() -> void:
	level += 1
	cpu_particles_2d.restart()
	if level < 9:
		player_scale = Util.size_to_scale[level - 1]
		player.scale = player_scale
	if level < 10:
		chage_texture(level - 1)
	audio_level_up.play()
	level_label.text = "Уровень " + str(level)
