extends Control

@onready var player: Sprite2D = $Player
@onready var audio_eat: AudioStreamPlayer = $AudioEat
@onready var fish_preload = preload("res://scenes/fish.tscn")

func _ready() -> void:
	for i in 50:
		var fish: Fish = fish_preload.instantiate()
		add_child(fish)
		await get_tree().create_timer(0.5).timeout


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	player.global_position = get_global_mouse_position() 


func on_eat_fish() -> void:
	audio_eat.play()


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	on_eat_fish()
