extends StaticBody3D

@export var ui_to_open: String;

func execute(options: Dictionary):
	Global.ui_root.enable_ui(Global.ui_root.find_child(ui_to_open))
