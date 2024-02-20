class_name FittingPuzzle
extends Control

var _rect_theme = preload("res://theming/inventory/theme_inventory_slot.tres")
var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");  
@onready var window: Window = $"../";

@export var _grid_size: Vector2i = Vector2i(2, 2)
var inventory_2d: Array[Array] = []
var items = []

#Will be populated on selection changed
var item_shape: Array = []
var item_selected: Dictionary = {}

signal item_added(id: String);
signal item_removed(id: String);

@export var visual_element: Control = self

func _on_item_clicked(data: Dictionary):
	if data && data.has("layout"):
		item_shape = Helpers.convert_to_2D(data.layout, 1)
	item_selected = data;
	
func _reset_item():
	item_shape = [];
	item_selected = {};

func _ready():
	visual_element.columns = _grid_size.y;
	var curr_arr: Array = []
	
	for i in range(_grid_size.x * _grid_size.y):
		var btn = item_ui_packed.instantiate();
		btn.slot_data = ItemSlot.new();
		btn.show_amount = false;
		visual_element.add_child(btn)
				
		btn.gui_input.connect(_on_slot_clicked.bind(btn))
		
		curr_arr.append(false)
		if i % visual_element.columns == visual_element.columns - 1:
			inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
	_deferred_ready.call_deferred();
	
func _deferred_ready():
	#window.inventory.item_clicked.connect(_on_item_clicked)
	window.close_requested.connect(on_close)

func _on_slot_clicked(event: InputEvent, btn: Button):
	var btn_index = visual_element.get_children().find(btn)
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			var item_connections = [];

			var intersections = _intersect(inventory_2d, item_shape, Vector2i(int(btn_index / float(visual_element.columns)), btn_index % visual_element.columns));
			if item_selected != {} && intersections.size() > 0:
				window.inventory.controller.remove_item(item_selected, 1);
				for intersection in intersections:
					item_connections.append({"x": intersection.y, "y": intersection.x, "key": item_selected.id, "index": intersection.x * visual_element.columns + intersection.y})
					set_state(intersection, item_selected.sprite)
				items.append(item_connections);
				item_added.emit(item_selected.id)
				item_selected = {};
		elif event.button_index == 2:
			var shape = get_item_shape_indices(btn_index);
			if shape != []:
				reset_tiles(shape);
				items.erase(shape);
				item_removed.emit(shape[0].key)
				_reset_item()
			

func set_state(intersection: Vector2i, sprite: Texture):
	inventory_2d[intersection.y][intersection.x] = true;
	(visual_element.get_children()[intersection.x * visual_element.columns + intersection.y] as Button).icon = sprite;
				
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
		visual_element.get_child(tile.index).icon = null;
	window.inventory.controller.add_item(ItemManager.get_item(clicked_shape[0].key), 1);

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
