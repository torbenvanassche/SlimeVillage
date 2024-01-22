extends GridContainer

@export var data: Array[bool] = [true]
@export var column_count = 1;
@export var pivot_index: int = 0;

var relative_store: Array[Vector2i] = []

var offset: Vector2 = Vector2();
var realtime_position: Vector2;

func open():
	for c in get_children():
		c.queue_free()
		
	columns = column_count;
	var arr_2d: Array = []
	var curr_arr: Array = []
		
	for x in data:
		var rect = ColorRect.new();
		rect.custom_minimum_size = Vector2i(50, 50);
		rect.color = Color(0, 0, 0, 0.5) if x else Color.TRANSPARENT;
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE;
		
		curr_arr.append(x)
		if get_child_count() % column_count == column_count - 1:
			arr_2d.append(curr_arr.duplicate());
			curr_arr.clear();
		add_child(rect)
		
	offset = (get_child(pivot_index).position + get_child(pivot_index).size / 2)
	
	_relativate_pivot(arr_2d)

func _relativate_pivot(data: Array):
	relative_store.clear();
	var row = pivot_index / column_count;
	var col = pivot_index % column_count;
	
	for x in range(data.size()):
		for y in range(data[x].size()):
			if data[x][y]:
				relative_store.append(Vector2i(y, x) - Vector2i(col, row));
