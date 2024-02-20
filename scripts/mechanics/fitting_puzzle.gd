class_name FittingPuzzle
extends Control

var _rect_theme = preload("res://theming/inventory/theme_inventory_slot.tres")
var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");  
@onready var window: Window = $"../";

@export var _grid_size: Vector2i = Vector2i(2, 2)
var inventory_2d: Array[Array] = []
var items = []

signal item_added(id: String);
signal item_removed(id: String);

@export var visual_element: Control = self

func _ready():
	visual_element.columns = _grid_size.y;
	var curr_arr: Array = []
	
	for i in range(_grid_size.x * _grid_size.y):
		var btn = item_ui_packed.instantiate() as ItemSlotUI;
		btn.set_reference(ItemSlot.new(true, "Puzzle"));
		btn.show_amount = false;
		visual_element.add_child(btn)
		
		curr_arr.append(false)
		if i % visual_element.columns == visual_element.columns - 1:
			inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
	_deferred_ready.call_deferred();
	
func _deferred_ready():
	window.close_requested.connect(on_close)

func add_item(btn: ItemSlotUI, item: Dictionary):
	var btn_index = visual_element.get_children().find(btn)
	var item_shape = Helpers.convert_to_2D(item.layout, 1)
	var item_connections = [];
	item.count = 1;

	var intersections = _intersect(inventory_2d, item_shape, Vector2i(int(btn_index / float(visual_element.columns)), btn_index % visual_element.columns));
	if intersections.size() > 0:
		for intersection in intersections:
			item_connections.append({"x": intersection.y, "y": intersection.x, "key": item.id, "index": intersection.x * visual_element.columns + intersection.y})
			var ui_item = (visual_element.get_children()[intersection.x * visual_element.columns + intersection.y] as ItemSlotUI);
			ui_item.slot_data.add(item, item.count)
			inventory_2d[intersection.y][intersection.x] = true;
			btn.redraw()
		items.append(item_connections);
		item_added.emit(item.id)

func reset_tiles(btn: ItemSlotUI):
	var btn_index = visual_element.get_children().find(btn)
	
	var clicked_shape = []
	for item_shape in items:
		for tile in item_shape:
			if tile.index == btn_index:
				clicked_shape = item_shape;
		
	for tile in clicked_shape:
		inventory_2d[tile.x][tile.y] = false;
		visual_element.get_child(tile.index).icon = null;

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
	
func on_close():
		visible = false;
