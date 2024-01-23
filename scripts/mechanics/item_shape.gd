class_name Shaper
extends GridContainer

var shape_data: Array = [];

func _clear():
	for c in get_children():
		c.queue_free()

func open(data: Array[bool] = [true], column_count = 1, visual: bool = false):		
	columns = column_count;
	var curr_arr: Array = []
	shape_data.clear()
		
	for x in range(data.size()):	
		if visual:
			_add_visual(data[x])
			
		curr_arr.append(data[x])
		if x % column_count == column_count - 1:
			shape_data.append(curr_arr.duplicate());
			curr_arr.clear();

func _add_visual(b: bool):
	var rect = ColorRect.new();
	rect.custom_minimum_size = Vector2i(50, 50);
	rect.color = Color(0, 0, 0, 0.5) if b else Color.TRANSPARENT;
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	add_child(rect)
