class_name transition
extends Node

@export var scene_name: String;

func execute():
	Global.manager.set_active_scene(Global.manager.get_scene_by_name(scene_name))
