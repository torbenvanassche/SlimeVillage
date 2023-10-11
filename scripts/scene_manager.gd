class_name SceneManager
extends Node3D

@export var scenes: Array[Node]
@export var initial_scene: Node

signal scene_changed(from: Node, to: Node)
	
var active_scene: Node:
	set(value): 
		if active_scene:
			self.remove_child(active_scene)
			
		scene_changed.emit(active_scene, value)
		
		active_scene = value
		if not value.get_parent():
			self.add_child(active_scene)
	get:
		return active_scene

func get_scene(scene_name: String):
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
