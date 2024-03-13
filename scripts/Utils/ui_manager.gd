class_name UIManager
extends Node

@onready var pause_menu: Node = get_subwindow("PAUSE");
@export var window_data: Dictionary = {};
var scene_history: Array[Node] = []

func _init():
	Global.ui_root = self;

func _unhandled_input(event):
	if event.is_action_pressed("inventory_open") && !get_tree().paused && !get_subwindow("INVENTORY").visible:
		enable_ui(get_subwindow("INVENTORY"))
		
	if event.is_action_pressed("cancel"):
		if get_children().all(func(x): return !x.visible || x == pause_menu):
			get_viewport().set_input_as_handled()
			pause_menu.pause(!get_tree().paused)

func ui_is_open():
	return get_children().all(func(x): return !x.visible);
	
func get_subwindow(s: String) -> Node:
	if window_data.has(s):
		if window_data[s] is NodePath:
			window_data[s] = get_node_or_null(window_data[s]);
		return window_data[s];
	else: 
		printerr("The provided key does not have an associated window.")
		return null;

func enable_ui(to_enable: Node, add_to_undo_stack: bool = true, options: Dictionary = {}):	
	if to_enable:
		to_enable.visible = true;		
		
		if add_to_undo_stack && !scene_history.has(to_enable):
			scene_history.append(to_enable);
		
func disable_ui(to_disable: Node, return_to_previous = true):
	to_disable.visible = false;
	if scene_history.has(to_disable):
		scene_history.erase(to_disable);
	if return_to_previous && scene_history.size() != 0:
		scene_history.back().visible = true;
	
func reset_history():
	scene_history.clear()

func get_global_mouse_position():
	return get_viewport().get_mouse_position()
