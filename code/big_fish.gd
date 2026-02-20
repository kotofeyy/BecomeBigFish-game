class_name BigFish
extends Sprite2D


var size_screen
var direction
var speed = 140
var can_swim = false


func _ready() -> void:
	size_screen = get_window().get_visible_rect().size


func _process(delta: float) -> void:
	if can_swim:
		if direction == "left":
			move_to_left(delta)
		if direction == "right":
			move_to_right(delta)


func stop_swim() -> void:
	visible = false
	can_swim = false


func spawn() -> void:
	can_swim = true
	visible = true
	direction = ["left", "right"].pick_random()
	if direction == "left":
		global_position.x = 0
		global_position.y = randi_range(45, size_screen.y - 32)
		flip_h = true
	if direction == "right":
		global_position.x = size_screen.x
		global_position.y = randi_range(45, size_screen.y - 32)
		flip_h = false
		

func move_to_left(delta) -> void:
	position.x += speed * delta


func move_to_right(delta) -> void:
	position.x -= speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if can_swim:
		spawn()
