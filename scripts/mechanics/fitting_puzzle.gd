class_name FittingPuzzle
extends GridContainer

@export var _grid_size: Vector2i = Vector2i(2, 2)
var inventory_2d: Array[Array] = []
var _rect_theme = preload("res://themes/inventory/inventory_slot.tres")
@export var window: Window;

func _ready():
	self.columns = _grid_size.y;
	var curr_arr: Array = []
	
	for i in range(_grid_size.x * _grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		btn.expand_icon = true;
		btn.theme = _rect_theme;	
		self.add_child(btn)
				
		btn.pressed.connect(_add_selected_item.bind(btn))
		
		curr_arr.append(false)
		if i % self.columns == self.columns - 1:
			inventory_2d.append(curr_arr.duplicate());
			print(curr_arr)
			curr_arr.clear();
		
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()
		
func _add_selected_item(btn: Button):
	var selected = window.inventory_ui.selected_item;
	var shape = window.item_layout.shape_data;

	var btn_index = self.get_children().find(btn)
	var intersections = _intersect(inventory_2d, shape, Vector2i(btn_index / columns, btn_index % columns));
	if selected && intersections.size() > 0:
		Global.player_instance.inventory.remove_item(selected, 1);
		for intersection in intersections:
			inventory_2d[intersection.y][intersection.x] = true;
			(self.get_children()[intersection.x * self.columns + intersection.y] as Button).icon = selected.sprite;

func _intersect(inventory, item, chosen_position: Vector2i) -> Array:
	var result = [];

	for row_idx in item.size():
		var row = item[row_idx]
		for col_idx in row.size():
			var item_state: bool = row[col_idx]
			if row_idx+chosen_position.x >= inventory.size() || col_idx+chosen_position.y >= inventory[row_idx+chosen_position.x].size():
				return [];
			elif inventory[row_idx+chosen_position.y][col_idx+chosen_position.x] and item_state:
				return [];
			elif item_state:
				result.append(Vector2i(row_idx+chosen_position.x, col_idx+chosen_position.y))
	return result
