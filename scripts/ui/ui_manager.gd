class_name UIManager
extends Node

@export var puzzle_ui: Window
@export var player_inventory: Window;
@onready var pause_menu: Node = $pause_menu;

var scene_history: Array[Node] = []

func _init():
	Global.ui_root = self;

func _unhandled_input(event):
	if event.is_action_pressed("inventory_open"):
		player_inventory.enable()
		
	if event.is_action_pressed("cancel"):
		if get_children().all(func(x): return !x.visible || x == pause_menu):
			get_viewport().set_input_as_handled()
			pause_menu.pause(!get_tree().paused)

func ui_is_open():
	return get_children().all(func(x): return !x.visible);

func enable_ui(to_enable: Node, add_to_undo_stack = true):
	to_enable.visible = true;
	if add_to_undo_stack && !scene_history.has(to_enable):
		scene_history.append(to_enable);
		
func disable_ui(to_disable: Node, return_to_previous = true):
	to_disable.visible = false;
	if scene_history.has(to_disable):
		scene_history.erase(to_disable);
		if return_to_previous:
			scene_history.back().visible = true;
	
func reset_history():
	scene_history.clear()
