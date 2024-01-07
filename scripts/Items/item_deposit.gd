extends Node

func _ready():
	self.get_parent().initialize({});

func execute():
	print(Global.ui_root.puzzle_ui)
	Global.ui_root.puzzle_ui.visible = true;
	pass
