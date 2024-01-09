class_name Manager
extends Node3D

@export var scenes: Array[Node]
@export var initial_scene: Node
@export var UI_manager: UIManager;

signal scene_changed(from: Node, to: Node)
	
var active_scene: Node
		
func set_active_scene(scene: Node, remove_active_from_tree: bool = true):
	if active_scene && remove_active_from_tree:
		active_scene.set_meta("last_tile", Global.player_instance.current_tile)
		active_scene.visible = false;
		
	scene_changed.emit(active_scene, scene)
	
	active_scene = scene
	active_scene.visible = true;
		
	if active_scene.has_method("on_enable"):
		active_scene.on_enable();
		
	if active_scene.has_meta("last_tile"):
		Global.player_instance.current_tile = active_scene.get_meta("last_tile")
	else:
		Global.player_instance.current_tile = active_scene.entrance;
	Global.player_instance.set_position_to_current_tile();                   

		
func get_active_scene():
	return active_scene

func get_scene_by_name(scene_name: String):
	var filtered = scenes.filter(func(x: Node): return x.name == scene_name)
	if filtered.size() > 0:
		return filtered[0]
	else:
		return null
		
func _ready():
	Global.manager = self
	active_scene = initial_scene

	if active_scene.has_method("on_enable"):
		active_scene.on_enable();
	
	for s in scenes:
		if s != initial_scene:
			s.visible = false;

func pause(pause_game = true):
	get_tree().paused = pause_game
	if get_tree().paused:
		$pause_menu.show()
	else:
		$pause_menu.hide()
		

func _unhandled_input(_event):
	if Input.is_action_just_released("cancel"):
		pause(!get_tree().paused)
