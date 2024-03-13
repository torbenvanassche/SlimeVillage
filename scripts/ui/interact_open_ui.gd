class_name InteractionOpenUI
extends Interaction

@export var add_to_undo: bool = true;
@export var window_id: String = "PLACEHOLDER";

func execute(_options: Dictionary = {}):
	var selected_window = Global.ui_root.get_subwindow(window_id)
	var position := Vector2.ZERO;
	Global.ui_root.enable_ui(selected_window, add_to_undo)
