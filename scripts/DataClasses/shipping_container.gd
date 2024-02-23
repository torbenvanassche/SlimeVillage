class_name ShippingContainer
extends Resource

var inventory_2d: Array[Array] = []
var items = []

func get_tile(btn_index: int):	
	var clicked_shape = []
	for item_shape in items:
		for tile in item_shape:
			if tile.index == btn_index:
				clicked_shape = item_shape;
				
	return clicked_shape;

func intersect(item, chosen_position: Vector2i) -> Array:
	var result = [];
	for row_idx in item.size():
		var row = item[row_idx]
		for col_idx in row.size():
			var item_state: bool = row[col_idx]
			if row_idx+chosen_position.x >= inventory_2d.size() || col_idx+chosen_position.y >= inventory_2d[row_idx+chosen_position.x].size():
				return [];
			elif inventory_2d[row_idx+chosen_position.y][col_idx+chosen_position.x] and item_state:
				return [];
			elif item_state:
				result.append(Vector2i(row_idx+chosen_position.x, col_idx+chosen_position.y))
	return result
