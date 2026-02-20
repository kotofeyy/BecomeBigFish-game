extends Control

@onready var player: Sprite2D = $Player
@onready var fishes: Node2D = $Fishes
@onready var audio_eat: AudioStreamPlayer = $AudioEat
@onready var audio_level_up: AudioStreamPlayer = $AudioLevelUp
@onready var audio_wrong: AudioStreamPlayer = $AudioWrong
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var wrong_panel: Panel = $CanvasLayer/WrongPanel
@onready var player_shield: Panel = $Player/PlayerShield
@onready var heart_control: Control = $CanvasLayer/Header/MarginContainer/VBoxContainer/HeartControl/HBoxContainer
@onready var heart_sprite: TextureRect = $CanvasLayer/HeartSprite
@onready var shield_ability: Sprite2D = $ShieldAbility
@onready var heart_ability: Sprite2D = $HeartAbility
@onready var magnet_ability: Sprite2D = $MagnetAbility
@onready var progress_bar: ProgressBar = $CanvasLayer/Header/MarginContainer/VBoxContainer/ProgressBar
@onready var level_label: Label = $CanvasLayer/Header/MarginContainer/VBoxContainer/LevelLabel
@onready var animated_sprite_eat: AnimatedSprite2D = $AnimatedSpriteEat
@onready var start_game_button: Button = $CanvasLayer/StartGameButton
@onready var end_game_panel: Panel = $CanvasLayer/EndGamePanel
@onready var count_of_fish_label: Label = $CanvasLayer/EndGamePanel/MarginContainer/VBoxContainer/CountOfFishLabel
@onready var clue_label: Label = $CanvasLayer/ClueLabel

@onready var fish_preload = preload("res://scenes/fish.tscn")

@onready var slot_preload = preload("uid://dnm2kegprv65j")
@onready var shop_panel: Panel = $CanvasLayer/ShopPanel
@onready var shop_list: VBoxContainer = $CanvasLayer/ShopPanel/MarginContainer/ScrollContainer/VBoxContainer
@onready var skin_button: Button = $CanvasLayer/SkinButton
@onready var all_scores_label: Label = $CanvasLayer/ShopPanel/AllScoresLabel


var has_game_started := false
var player_scale
var score = 0
var level = 1
var heart = 3
var max_value_of_progress_bar = 10
var game_is_started = false
var count_of_fishes = 20
var size_screen
var center_of_screen
var is_shield_enable = false
var available_skins := 1
var current_skin := Skins.Type.DEFAULT
var all_scores = 100


func _ready() -> void:
	clue_label.text = "KEY_PAUSE"
	size_screen = get_window().get_visible_rect().size
	center_of_screen = size_screen / 2
	shop_update()
	all_scores_label.text = "Всего очков: " + str(all_scores)


func start_game() -> void:
	get_tree().paused = false
	skin_button.visible = false
	score = 0
	level = 1
	heart = 3
	update_heart()
	change_texture(level - 1)
	player_change_skin()
	progress_bar.max_value = level * 10
	progress_bar.min_value = score
	progress_bar.value = score
	player_scale = Util.size_to_scale[level - 1]
	player.scale = player_scale
	clear_fishes()
	spawn_fishes()
	level_label.text = tr("KEY_LEVEL") + " " + str(level)


func clear_fishes() -> void:
	var children = fishes.get_children()
	for fish in children:
		fish.queue_free()


func spawn_fishes() -> void:
	for i in count_of_fishes:
		var fish: Fish = fish_preload.instantiate()
		fish.level = level
		fishes.add_child(fish)
		await get_tree().create_timer(0.3).timeout


func _process(_delta: float) -> void:
	if progress_bar.ratio == 1.0:
		progress_bar.value = 0
		level_up()
		clear_fishes()
		spawn_fishes()
		progress_bar.min_value = score
		max_value_of_progress_bar = max_value_of_progress_bar * 1.4
		print("max value of progress bar - ", max_value_of_progress_bar)
		progress_bar.max_value = level * max_value_of_progress_bar
	if  game_is_started:
		# добавил немного вязкозти, для ощущения под водой
		var weight = 0.1
		player.global_position = player.global_position.lerp(get_global_mouse_position(), weight)
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _unhandled_input(_event: InputEvent) -> void:
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


func on_wrong_eating() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(wrong_panel, "modulate:a", 1.0, 0.1)
	tween.chain().tween_property(wrong_panel, "modulate:a", 0.0, 0.1)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.name == "ShieldAbility":
		audio_eat.play()
		shield_ability.position = Vector2(-100, 0)
		on_shield_enable()
	if parent.name == "HeartAbility":
		audio_eat.play()
		heart_ability.position = Vector2(-100, 0)
		on_heart_enable()
	if parent.name == "MagnetAbility":
		audio_eat.play()
		magnet_ability.position = Vector2(-100, 0)
		on_magnet_enable()
	else:
		if parent is Fish:
			if player_scale >= parent.fish_scale:
				on_eat_fish(parent.global_position)
				parent.reset_spawn()
			else:
				if not is_shield_enable:
					audio_wrong.play()
					on_wrong_eating()
					parent.reset_spawn()
					if heart > 1:
						heart -= 1
						update_heart()
					else:
						heart -= 1
						update_heart()
						on_dead()


func update_progress() -> void:
	progress_bar.value = score


func change_texture(index: int) -> void:
	var tile_size = 16
	var x = (index % 3) * tile_size
	var y = (index / 3) * tile_size
	
	player.region_rect = Rect2(x, y, tile_size, tile_size)


func level_up() -> void:
	level += 1
	cpu_particles_2d.restart()
	if level > 6:
		scale = Vector2(0.8, 0.8)
	if level > 8:
		scale = Vector2(0.7, 0.7)
	if level > 9:
		count_of_fishes = 20
	if level < 10:
		player_scale = Util.size_to_scale[level - 1]
		player.scale = player_scale
	if level < 10:
		change_texture(level - 1)
	audio_level_up.play()
	level_label.text = "Уровень " + str(level)


func _on_start_game_button_pressed() -> void:
	game_is_started = true
	start_game_button.visible = false
	start_game()


func on_heart_dropping() -> void:
	heart_ability.position.x = randi_range(40, size_screen.x - 40)
	var tween = get_tree().create_tween()
	tween.tween_property(heart_ability, "position:y", size_screen.y + 100, 5.0)
	tween.finished.connect(func(): 
		heart_ability.position = Vector2(-200, 0))


func on_shield_dropping() -> void:
	shield_ability.position.x = randi_range(40, size_screen.x - 40)
	var tween = get_tree().create_tween()
	tween.tween_property(shield_ability, "position:y", size_screen.y + 100, 5.0)
	tween.finished.connect(func(): 
		shield_ability.position = Vector2(-200, 0))


func on_magnet_dropping() -> void:
	magnet_ability.position.x = randi_range(40, size_screen.x - 40)
	var tween = get_tree().create_tween()
	tween.tween_property(magnet_ability, "position:y", size_screen.y + 100, 5.0)
	tween.finished.connect(func(): 
		magnet_ability.position = Vector2(-200, 0))


func on_shield_enable() -> void:
	is_shield_enable = true
	player_shield.visible = true
	await get_tree().create_timer(5).timeout
	player_shield.visible = false
	is_shield_enable = false


func on_heart_enable() -> void:
	if heart < 3:
		heart += 1
	update_heart()


func on_magnet_enable() -> void:
	var children = fishes.get_children()
	for fish: Fish in children:
		if fish.fish_scale <= player_scale:
			on_shield_enable()
			var tween = get_tree().create_tween()
			tween.tween_property(fish, "position", player.position, 0.5)


func update_heart() -> void:
	var children = heart_control.get_children()
	for child in children:
		child.queue_free()
	for h in heart:
		var new_heart = heart_sprite.duplicate()
		heart_control.add_child(new_heart)


func _on_timer_for_shield_timeout() -> void:
	if game_is_started:
		on_shield_dropping()
		on_magnet_dropping()


func _on_timer_for_heart_timeout() -> void:
	if game_is_started:
		on_heart_dropping()


func on_dead() -> void:
	game_is_started = false
	end_game_panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	clear_fishes()
	count_of_fish_label.text = tr("KEY_FISH_EATEN") + ": " + str(score)


func _on_restart_button_pressed() -> void:
	game_is_started = true
	end_game_panel.visible = false
	start_game()


func _on_cancel_button_pressed() -> void:
	clear_fishes()
	start_game_button.visible = true
	end_game_panel.visible = false
	game_is_started = false
	skin_button.visible = true


func _on_skin_button_pressed() -> void:
	shop_panel.visible = true
	_set_current_selected()
	shop_update()


func _set_current_selected() -> void:
	var childs = shop_list.get_children()
	
	for child: Slot in childs:
		child.select(current_skin)


func unlock_skin(skin_value: int):
	available_skins = available_skins | skin_value


func has_skin(skin_value: int) -> bool:
	return (available_skins & skin_value) != 0


func shop_update() -> void:
	var children = shop_list.get_children()
	for child in children:
		child.queue_free()

	for s in Skins.List:
		var slot: Slot = slot_preload.instantiate()
		slot.skin = s
		slot.cost =  Skins.List[s]["cost"]
		slot.all_scores = all_scores
		slot.available = has_skin(Skins.TypeToBit[s])
		slot.type = Skins.List[s]["type"]
		slot.replace_color = Skins.List[s]["color"]
		slot.on_click.connect(func(skin, can_buy):
			if can_buy and not has_skin(Skins.TypeToBit[skin]): 
				unlock_skin(Skins.TypeToBit[skin])
				all_scores = all_scores - int(Skins.List[skin]["cost"])
				all_scores_label.text = "Всего очков: " + str(all_scores)
				#save_data()
			if has_skin(Skins.TypeToBit[skin]):
				slot.select(skin)
				shop_panel.visible = false
				current_skin = skin
				player_change_skin()
				#icon.animation = str(skin)
		)
		shop_list.add_child(slot)
		slot.select(current_skin)


func player_change_skin() -> void:
	var material: ShaderMaterial = player.material.duplicate()
	if Skins.List[current_skin]["type"] == "color":
		material.set_shader_parameter("replace_color", Skins.List[current_skin]["color"])
		material.set_shader_parameter("is_rainbow", false)
	if Skins.List[current_skin]["type"] == "rainbow":
		
		material.set_shader_parameter("is_rainbow", true)
	
	player.material = material
