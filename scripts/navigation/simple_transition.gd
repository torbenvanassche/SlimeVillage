class_name transition
extends Node

@export var scene_name: String;

func execute():
	Global.scene_manager.set_active_scene(Global.scene_manager.get_scene_by_name(scene_name))
