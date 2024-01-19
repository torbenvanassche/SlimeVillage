class_name UIManager
extends Node

@export var puzzle_ui: Window
@export var player_inventory: Window;
@onready var pause_menu: Node = $pause_menu;

func _init():
	Global.ui_root = self;

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		if get_children().all(func(x): return !x.visible || x == pause_menu):
			get_viewport().set_input_as_handled()
			pause_menu.pause(!get_tree().paused)

func ui_is_open():
	return get_children().all(func(x): return !x.visible);
