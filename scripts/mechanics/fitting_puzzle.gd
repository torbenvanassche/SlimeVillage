class_name FittingPuzzle
extends GridContainer

@export var _grid_size: Vector2i = Vector2i(2, 2)
var inventory_2d: Array[Array] = []
var _rect_theme = preload("res://theming/inventory/theme_inventory_slot.tres")
@export var window: Window;

var items = []

signal item_added(id: String);
signal item_removed(id: String);

func _ready():
	self.columns = _grid_size.y;
	var curr_arr: Array = []
	
	for i in range(_grid_size.x * _grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		btn.expand_icon = true;
		btn.theme = _rect_theme;	
		self.add_child(btn)
				
		btn.gui_input.connect(_on_slot_clicked.bind(btn))
		
		curr_arr.append(false)
		if i % self.columns == self.columns - 1:
			inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
		
func _on_slot_clicked(event: InputEvent, btn: Button):
	var btn_index = self.get_children().find(btn)
	if event is InputEventMouseButton and event.is_pressed():
		var selected = window.inventory_ui.selected_item;
		if event.button_index == 1:
			var shape = window.item_layout.shape_data;
			var item_connections = [];

			var intersections = _intersect(inventory_2d, shape, Vector2i(int(btn_index / float(columns)), btn_index % columns));
			if selected && intersections.size() > 0:
				Global.player_instance.inventory.remove_item(selected, 1);
				for intersection in intersections:
					item_connections.append({"x": intersection.y, "y": intersection.x, "key": selected.id, "index": intersection.x * self.columns + intersection.y})
					set_state(intersection, selected.sprite)
				window.inventory_ui.reset_selection();
				items.append(item_connections);
				item_added.emit(selected.id)
		elif event.button_index == 2:
			reset_tiles(get_item_shape_indices(btn_index))
			item_removed.emit(selected.id)

func set_state(intersection: Vector2i, sprite: Texture):
	inventory_2d[intersection.y][intersection.x] = true;
	(self.get_children()[intersection.x * self.columns + intersection.y] as Button).icon = sprite;
				
func get_item_shape_indices(btn_index: int):
	var clicked_shape = []
	for item_shape in items:
		for tile in item_shape:
			if tile.index == btn_index:
				clicked_shape = item_shape;
	return clicked_shape;
				
func reset_tiles(clicked_shape: Array):
	for tile in clicked_shape:
		inventory_2d[tile.x][tile.y] = false;
		self.get_child(tile.index).icon = null;
	Global.player_instance.inventory.add_item(ItemManager.get_item(clicked_shape[0].key), 1);

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
