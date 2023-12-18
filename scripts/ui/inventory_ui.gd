class_name InventoryUI
extends Control

var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display.tscn");
var elements: Array[ItemViewer] = []

func add(item: Dictionary):
	var item_ui = item_ui_packed.instantiate() as ItemViewer;
	self.add_child(item_ui);
	elements.append(item_ui);
	item_ui.set_item(item);

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func update(data: Array[Dictionary]):
	_clear();
	for index in range(data.size()):
		add(data[index])
