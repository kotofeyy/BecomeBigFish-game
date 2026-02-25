class_name SystemDroppingAbility
extends Node

@onready var shield_ability: Sprite2D = $"../ShieldAbility"
@onready var heart_ability: Sprite2D = $"../HeartAbility"
@onready var magnet_ability: Sprite2D = $"../MagnetAbility"


var can_dropped = true
var size_screen


func _ready() -> void:
	size_screen = get_window().get_visible_rect().size


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


func _on_timer_for_heart_timeout() -> void:
	if can_dropped:
		on_heart_dropping()


func _on_timer_for_shield_timeout() -> void:
	if can_dropped:
		on_shield_dropping()
		on_magnet_dropping()
