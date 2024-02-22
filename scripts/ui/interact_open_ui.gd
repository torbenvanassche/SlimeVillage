class_name InteractionOpenUI
extends Interaction

@export var add_to_undo: bool = true;
@export var window_id: String = "PLACEHOLDER";
@export var window_title: String;
@export var use_mouse_position: bool = true;

func execute(options: Dictionary = {}):
	Global.ui_root.mechanic_window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN;
	var position := Vector2.ZERO;
	if use_mouse_position:
		position = Global.ui_root.get_global_mouse_position().clamp(Vector2(10, 35), Global.viewport.size - Global.ui_root.mechanic_window.size);
		Global.ui_root.mechanic_window.initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE;
	Global.ui_root.enable_ui(Global.ui_root.mechanic_window, window_title, window_id, position, add_to_undo)
