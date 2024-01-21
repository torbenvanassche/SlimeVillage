extends Node

@export var data: Array[bool] = [true]

func open():
	for c in get_children():
		c.queue_free()
		
	for x in data:
		var rect = ColorRect.new();
		rect.custom_minimum_size = Vector2i(50, 50);
		rect.color = Color(0, 0, 0, 0.5) if x else Color.WHITE;
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE;
		add_child(rect)
		
	self.visible = true;
		
func _input(event):
	if event is InputEventMouseMotion:
		self.global_position = event.global_position - Vector2(get_viewport().position);
