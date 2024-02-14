extends StaticBody3D

@export var ui_to_open: String;
@export var ui_position: Vector2 = Vector2.ZERO;
@export var use_mouse_position: bool = true;
@export var add_to_undo: bool = true;
@export var window_id: String = "PLACEHOLDER";
@export var window_title: String;

func _ready():
	if window_title.is_empty():
		window_title = window_id;

func execute(_options: Dictionary):
	if use_mouse_position:
		ui_position = Global.ui_root.get_global_mouse_position().clamp(Vector2(10, 35), get_tree().root.get_viewport().size - Global.ui_root.mechanic_window.size)
	Global.ui_root.enable_ui(Global.ui_root.mechanic_window, window_title, window_id, ui_position, add_to_undo)
