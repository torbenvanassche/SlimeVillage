class_name FittingPuzzle
extends Control

@onready var container: ShippingContainer = ShippingContainer.new();
var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");  
@onready var window: Window = $"../";

@export var _grid_size: Vector2i = Vector2i(2, 2)

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
			container.inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
	_deferred_ready.call_deferred();
	
func _deferred_ready():
	window.close_requested.connect(hide)

func add_item(btn: ItemSlotUI, item: Dictionary):
	var btn_index = visual_element.get_children().find(btn)
	var item_shape = Helpers.convert_to_2D(item.layout, item.layout_cols)
	var item_connections = [];
	item.count = 1;

	var intersections = container.intersect(item_shape, Vector2i(int(btn_index / float(visual_element.columns)), btn_index % visual_element.columns));
	if intersections.size() > 0:
		for intersection in intersections:
			item_connections.append({"x": intersection.y, "y": intersection.x, "key": item.id, "index": intersection.x * visual_element.columns + intersection.y})
			var ui_item = (visual_element.get_children()[intersection.x * visual_element.columns + intersection.y] as ItemSlotUI);
			ui_item.slot_data.add(item, item.count)
			container.set_tile(intersection.y, intersection.x, true)
			btn.redraw()
		container.add_item(item_connections);
		item_added.emit(item.id)

func reset_tiles(btn: ItemSlotUI):
	var clicked_shape = container.get_tile(visual_element.get_children().find(btn), true)	
	for tile in clicked_shape:
		container.set_tile(tile.x, tile.y, false);
		visual_element.get_child(tile.index).textureRect.texture = null
