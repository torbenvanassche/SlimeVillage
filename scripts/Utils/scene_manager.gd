class_name SceneManager
extends Node3D

@export var scenes: Array[Node]
@export var initial_scene: Node

signal scene_changed(from: Node, to: Node)
	
var active_scene: Node
		
func set_active_scene(scene: Node, remove_active_from_tree: bool = true):
	if active_scene && remove_active_from_tree:
		self.remove_child(active_scene)
		
	scene_changed.emit(active_scene, scene)
	
	active_scene = scene
	if not scene.get_parent():
		self.add_child(active_scene)
		
func get_active_scene():
	return active_scene

func get_scene_by_name(scene_name: String):
	var filtered = scenes.filter(func(x: Node): return x.name == scene_name)
	if filtered.size() > 0:
		return filtered[0]
	else:
		return null
		
func _ready():
	Global.scene_manager = self
	active_scene = initial_scene
	
	for s in scenes:
		if s != initial_scene:
			remove_child(s)

func pause(pause_game = true):
	get_tree().paused = pause_game
	if get_tree().paused:
		$pause_menu.show()
	else:
		$pause_menu.hide()
		

func _input(_event):
	if Input.is_action_just_released("open_pause"):
		pause(!get_tree().paused)
