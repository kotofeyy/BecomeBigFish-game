extends Sprite2D
class_name Fish


const FISH_1 = preload("uid://bifkics7rlbos")
const FISH_2 = preload("uid://dolbclvlvtwfk")
const FISH_3 = preload("uid://bcqprvaq42nnw")

var speed = 120
var direction
var size_screen
var fish_scale
var level = 1
var fish_level = 1
var level_to_scale = {
	1: [Util.Size.EXTRA_SMALL, Util.Size.SMALL, Util.Size.MEDIUM],
	2: [Util.Size.LARGE, Util.Size.EXTRA_LARGE, Util.Size.DOUBLE_LARGE],
	3: [Util.Size.HUGE, Util.Size.GIANT, Util.Size.COLOSSAL]
}
var level_to_texture = {
	1: [0, 1 ,2],
	2: [3, 4, 5],
	3: [6, 7, 8]
}


func _ready() -> void:
	size_screen = get_window().get_visible_rect().size
	reset_spawn()


func move_to_left(delta) -> void:
	position.x += speed * delta


func move_to_right(delta) -> void:
	position.x -= speed * delta


func _process(delta: float) -> void:
	if direction == "left":
		move_to_left(delta)
	if direction == "right":
		move_to_right(delta)
	


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	reset_spawn()


func reset_spawn() -> void:
	if level > 3:
		fish_level = 2
	if level > 6:
		fish_level = 3
	direction = ["left", "right"].pick_random()
	if direction == "left":
		chage_texture(level_to_texture[fish_level].pick_random())
		position.x = 0
		#level = randi_range(0, 2)
		fish_scale = Util.size_to_scale[level_to_scale[fish_level].pick_random()]
		scale = fish_scale
		flip_h = true
		global_position.y = randi_range(45, size_screen.y - 32)
	if direction == "right":
		chage_texture(level_to_texture[fish_level].pick_random())
		global_position.x = size_screen.x
		#level = randi_range(0, 2)
		fish_scale = Util.size_to_scale[level_to_scale[fish_level].pick_random()]
		scale = fish_scale
		flip_h = false
		global_position.y = randi_range(45, size_screen.y - 32)


func chage_texture(index: int) -> void:
	var tile_size = 16
	var x = (index % 3) * tile_size
	var y = (index / 3) * tile_size
	
	region_rect = Rect2(x, y, tile_size, tile_size)


	
