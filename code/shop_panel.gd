class_name ShopPanel
extends Panel

@onready var shop_list: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer
@onready var all_scores_label: Label = $AllScoresLabel

@onready var slot_preload = preload("res://scenes/slot.tscn")

signal select_skin

var all_scores:
	set(value):
		all_scores = value
		
var available_skins:
	set(value):
		available_skins = value

var current_skin:
	set(value):
		current_skin = value


func _ready() -> void:
	pass


func shop_update() -> void:
	all_scores_label.text = tr("KEY_SCORE") + ": " + str(all_scores)
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
				all_scores_label.text = tr("KEY_SCORE") + ": " + str(all_scores)
				#save_data()
			if has_skin(Skins.TypeToBit[skin]):
				slot.select(skin)
				visible = false
				current_skin = skin
				emit_signal("select_skin", current_skin, available_skins, all_scores)
		)
		shop_list.add_child(slot)
		slot.select(current_skin)


func unlock_skin(skin_value: int):
	available_skins = available_skins | skin_value


func has_skin(skin_value: int) -> bool:
	return (available_skins & skin_value) != 0


func show_self() -> void:
	shop_update()
	visible = !visible
