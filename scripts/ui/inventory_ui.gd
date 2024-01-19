class_name InventoryUI
extends Node #Window does not properly close when clicked outside ( https://github.com/godotengine/godot/issues/87291 )

var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");              
var elements: Array[ItemSlot] = []

var selected_item: Dictionary;

func add(dict: Dictionary):
	var item_ui = item_ui_packed.instantiate() as ItemSlot;
	add_child(item_ui);
	elements.append(item_ui);
	
	if dict.has("is_available"):
		item_ui.visible = dict.is_available;
		
	if !dict.has("item"):
		dict.item = {};
		
	item_ui.pressed.connect(_set_selected.bind(dict));
	
	if dict.item != {}:
		item_ui.set_item(dict);
	
func _set_selected(dict: Dictionary):
	selected_item = dict.item;
	
func reset_selection():
	selected_item.clear();

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func update(data: Array[Dictionary]):
	_clear();
	for index in range(data.size()):
		add(data[index])
