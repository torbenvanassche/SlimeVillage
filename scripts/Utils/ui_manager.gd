class_name UIManager
extends Node

@export var mechanic_window: Window
@export var player_inventory: Window;
@onready var pause_menu: Node = $pause_menu;

@export var window_data: Dictionary = {};

var scene_history: Array[Node] = []

func _init():
	Global.ui_root = self;
	window_data["test"] = self;

func _unhandled_input(event):
	if event.is_action_pressed("inventory_open") && !get_tree().paused:
		enable_ui("Inventory", player_inventory, "", get_global_mouse_position(), false)
		
	if event.is_action_pressed("cancel"):
		if get_children().all(func(x): return !x.visible || x == pause_menu):
			get_viewport().set_input_as_handled()
			pause_menu.pause(!get_tree().paused)

func ui_is_open():
	return get_children().all(func(x): return !x.visible);
	
func get_subwindow(s: String) -> Node:
	if window_data.has(s):
		if window_data[s] is NodePath:
			window_data[s] = get_node(window_data[s]);
		return window_data[s];
	else: 
		printerr("The provided key does not have an associated window.")
		return null;

func enable_ui(window_id: String, to_enable: Node, window_name: String = "", position: Vector2 = Vector2.ZERO, add_to_undo_stack: bool = true):
	to_enable.visible = true;
	if add_to_undo_stack && !scene_history.has(to_enable):
		scene_history.append(to_enable);
		
	if window_name.is_empty():
		window_name = window_id;
		
	if position != Vector2.ZERO:
		to_enable.position = position;
		
	if to_enable.has_method("on_enable"):
		to_enable.on_enable({"title": window_name, "id": window_id});
		
func disable_ui(to_disable: Node, return_to_previous = true):
	to_disable.visible = false;
	if scene_history.has(to_disable):
		scene_history.erase(to_disable);
		if return_to_previous:
			scene_history.back().visible = true;
	
func reset_history():
	scene_history.clear()

func get_global_mouse_position():
	return get_viewport().get_mouse_position()
