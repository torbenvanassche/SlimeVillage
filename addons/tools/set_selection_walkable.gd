@tool
extends EditorScript

var packed_scene: PackedScene = preload("res://scenes/components/tile.tscn")

func _run():
	var selected = get_editor_interface().get_selection().get_selected_nodes();
	for node in selected:
		var instance = packed_scene.instantiate();
		node.add_child(instance)
		instance.owner = get_scene()
