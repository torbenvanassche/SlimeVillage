class_name FittingPuzzle
extends GridContainer

@export var _grid_size: Vector2i = Vector2i(2, 2)
var _rect_theme = preload("res://scenes/ui/inventory_slot.tres")

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
	var selected = Global.player_instance.inventory.ui.selected_item;
	if selected:
		Global.player_instance.inventory.remove_item(selected, 1);
		btn.icon = selected.sprite;
		Global.player_instance.inventory.ui.reset_selection();
