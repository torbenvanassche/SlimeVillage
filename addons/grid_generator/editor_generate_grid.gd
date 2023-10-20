@tool
extends EditorPlugin

const addon: PackedScene = preload("res://addons/grid_generator/generate_grid_scene.tscn")
var docked_scene

func _enter_tree():
	docked_scene = addon.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, docked_scene)
	docked_scene.get_node("Button").pressed.connect(_on_press)
	
func _exit_tree():
	remove_control_from_docks(docked_scene)
	docked_scene.free()

func _on_press():
	pass
