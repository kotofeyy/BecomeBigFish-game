class_name BigFish
extends Sprite2D

@onready var timer: Timer = $Timer


var size_screen
var direction
var speed = 140
var can_swim = false


func _ready() -> void:
	size_screen = get_window().get_visible_rect().size
	timer.start(15)
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)


func stop_swim() -> void:
	visible = false
	can_swim = false


func start_swim() -> void:
	visible = true
	can_swim = true


func move_to_left() -> void:
	global_position.y = randi_range(45, size_screen.y - 32)
	global_position.x = 0
	flip_h = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", size_screen.x + 80, 5.5)


func move_to_right() -> void:
	global_position.y = randi_range(45, size_screen.y - 32)
	global_position.x = size_screen.x
	flip_h = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", -80, 5.5)


func _on_timer_timeout() -> void:
	if can_swim:
		direction = ["left", "right"].pick_random()
		if direction == "left":
			move_to_left()
		if direction == "right":
			move_to_right()
