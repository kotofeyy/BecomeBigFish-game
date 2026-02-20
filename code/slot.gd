class_name Slot
extends Panel

@onready var cost_label: Label = $MarginContainer/HBoxContainer/CostLabel

@onready var selected_slot: StyleBoxFlat = preload("res://themes/new_selected_slot.tres")
@onready var default_slot: StyleBoxFlat = preload("res://themes/default_slot.tres")
@onready var sprite_2d: Sprite2D = $MarginContainer/HBoxContainer/Control/Sprite2D


signal on_click

var cost
var skin
var all_scores
var available
var type
var replace_color


func _ready() -> void:
	if not available:
		cost_label.text = str(cost)
	else:
		cost_label.text = "Доступен"
	
	var material: ShaderMaterial = sprite_2d.material.duplicate()
	if type == "color":
		material.set_shader_parameter("replace_color", replace_color)
		material.set_shader_parameter("is_rainbow", false)
	if type == "rainbow":
		
		material.set_shader_parameter("is_rainbow", true)
	
	sprite_2d.material = material


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_pressed("mouse_action"):
		print("all scores - ", all_scores)
		print("cost - ", cost)
		var can_buy
		can_buy = all_scores >= cost 
		emit_signal("on_click", skin, can_buy)


func select(s: Skins.Type) -> void:
	if not available:
		focus_mode = Control.FOCUS_NONE
	else:
		if selected_slot:
			if s == skin:
				print("skin - ", s)
				add_theme_stylebox_override("panel", selected_slot)
				grab_focus()


func _clear_select() -> void:
	add_theme_stylebox_override("panel", default_slot)


func _on_focus_exited() -> void:
	_clear_select()
