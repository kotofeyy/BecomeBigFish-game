extends Panel
class_name Fish

var speed = 100
var direction
var size_screen

func _ready() -> void:
	var size_screen = get_window().get_visible_rect().size
	direction = ["left", "right"].pick_random()
	if direction == "left":
		position.y = randi_range(100, size_screen.y)
	if direction == "right":
		position.x = size_screen.x
		position.y = randi_range(0, size_screen.y)
	#var tween = get_tree().create_tween()
	#if direction == "left":
		#position.y = randi_range(100, size_screen.y)
		#tween.tween_property(self, "position", Vector2(size_screen.x, position.y), randf_range(1, 7))
	#if direction == "right":
		#position.x = size_screen.x
		#position.y = randi_range(0, size_screen.y)
		#tween.tween_property(self, "position", Vector2(0, position.y), randf_range(1, 7))


func _process(delta: float) -> void:
	if direction == "left":
		position.x += speed * delta
	if direction == "right":
		position.x -= speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	pass
	#queue_free()
