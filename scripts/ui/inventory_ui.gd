class_name InventoryUI
extends Control

var item_ui: PackedScene = preload("res://scenes/ui/item_display.tscn");

func add(item: Dictionary):
	var item_ui = item_ui.instantiate() as Item;
	item_ui.set_item(item);
	self.add_child(item_ui);
