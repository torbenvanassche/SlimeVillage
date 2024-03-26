class_name UIManager
extends Node

@onready var pause_menu: Node = get_subwindow("PAUSE");
@export var window_data: Dictionary = {};
var scene_history: Array[Node] = []

func _init():
	Global.ui_root = self;

func _ready():
	for c in get_children():
		c.visible = false;
		
func pause(pause_game = true):
	get_tree().paused = pause_game

func _unhandled_input(event):
	if event.is_action_pressed("inventory_open") && !get_tree().paused:
		enable_ui(get_subwindow("INVENTORY"))
		
	if event.is_action_pressed("debug_open_puzzle") && !get_tree().paused:
		enable_ui(get_subwindow("PUZZLE"))
		
	if event.is_action_pressed("cancel") && ui_is_closed():
		get_viewport().set_input_as_handled()
		pause(!get_tree().paused)
		if get_tree().paused:
			enable_ui(pause_menu, true)

func ui_is_closed():
	return get_children().all(func(x): return !x.visible || x == pause_menu);
	
func get_subwindow(s: String) -> Node:
	if window_data.has(s):
		if window_data[s] is NodePath:
			window_data[s] = get_node_or_null(window_data[s]);
		return window_data[s];
	else: 
		printerr("The provided key does not have an associated window.")
		return null;

func enable_ui(to_enable: Node, add_to_undo_stack: bool = true, options: Dictionary = {}):
	if options.has("hide"):
		options.hide.visible = false;

	if to_enable:
		if to_enable.has_method("on_enable"):
			to_enable.on_enable(options)
		
		if add_to_undo_stack && !scene_history.has(to_enable):
			scene_history.append(to_enable);
		
func disable_ui(to_disable: Node, return_to_previous = true):
	to_disable.visible = false;
	if scene_history.has(to_disable):
		scene_history.erase(to_disable);
	if return_to_previous && scene_history.size() != 0:
		scene_history.back().visible = true;
	pause(!ui_is_closed())
	
func reset_history():
	scene_history.clear()

func get_global_mouse_position():
	return get_viewport().get_mouse_position()
