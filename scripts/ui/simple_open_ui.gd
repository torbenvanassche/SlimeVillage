extends StaticBody3D

@export var ui_to_open: String;
@export var ui_position: Vector2 = Vector2.ZERO;
@export var use_mouse_position: bool = true;
@export var add_to_undo: bool = true;

@onready var ui_element: Window = Global.ui_root.find_child(ui_to_open);

func execute(_options: Dictionary):
	if use_mouse_position:
		ui_position = Global.ui_root.get_global_mouse_position().clamp(Vector2(10, 35), get_tree().root.get_viewport().size - ui_element.size)
	Global.ui_root.enable_ui(ui_element, ui_position, add_to_undo)
