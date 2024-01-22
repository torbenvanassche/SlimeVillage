class_name FittingPuzzle
extends GridContainer

@export var _grid_size: Vector2i = Vector2i(2, 2)
var _rect_theme = preload("res://themes/inventory/inventory_slot.tres")
@export var window: Window;

func _ready():
	self.columns = _grid_size.y;
	for i in range(_grid_size.x * _grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		btn.expand_icon = true;
		btn.theme = _rect_theme;	
		self.add_child(btn)
		
		btn.pressed.connect(_add_selected_item.bind(btn))
		
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()
		
func _add_selected_item(btn: Button):
	var selected = window.inventory_ui.selected_item;
	var shape = window.item_layout.relative_store;
	
	var btn_index = get_children().find(btn)
	
	for coord:Vector2i in shape:
		pass
	
	if selected && btn.icon == null:
		Global.player_instance.inventory.remove_item(selected, 1);
		btn.icon = selected.sprite;
