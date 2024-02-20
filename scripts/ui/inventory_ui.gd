class_name InventoryUI
extends Control #Window does not properly close when clicked outside ( https://github.com/godotengine/godot/issues/87291 )

var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");              
var elements: Array[ItemSlotUI] = []

var selected_item: Dictionary;
var controller: Inventory;

@export var show_locked: bool = false;
@export var visual_element: Control = self;

func set_controller(con: Inventory):
	if controller && con != controller:
		controller.inventory_changed.disconnect(_update)
	controller = con;
	if !controller.inventory_changed.is_connected(_update):
		controller.inventory_changed.connect(_update);
	controller.refresh_ui();

func add(dict: ItemSlot):
	var item_ui = item_ui_packed.instantiate() as ItemSlotUI;
	visual_element.add_child(item_ui);
	elements.append(item_ui);
	
	if show_locked:
		item_ui.disabled = !dict.is_available;
	else:
		item_ui.visible = dict.is_available;
	item_ui.set_reference(dict);
	
func _set_selected(dict: Dictionary):
	selected_item = dict.item;

func reset_selection():
	selected_item = {}

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func _update(data: Array[ItemSlot]):
	_clear();
	for index in range(data.size()):
		add(data[index])
		
func on_enable():
	set_controller(Global.player_instance.inventory);
	controller.refresh_ui();
