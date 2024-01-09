class_name FittingPuzzle
extends GridContainer

@export var grid_size: Vector2i = Vector2i(2, 2)
var rect_theme = preload("res://scenes/ui/inventory_slot.tres")

func _ready():
	self.columns = grid_size.y;
	for i in range(grid_size.x * grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		btn.expand_icon = true;
		btn.theme = rect_theme;	
		self.add_child(btn)
		
		btn.pressed.connect(_add_selected_item.bind(btn))
		
func _unhandled_input(_event):
	if Input.is_action_just_released("cancel"):
		self.visible = false;
		get_viewport().set_input_as_handled()
		
func _add_selected_item(btn: Button):
	var selected = Global.player_instance.inventory.ui.selected_item;
	if selected:
		Global.player_instance.inventory.remove_item(selected, 1);
		btn.icon = selected.sprite;
		Global.player_instance.inventory.ui.reset_selection();
