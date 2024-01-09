@tool
extends EditorScript

var packed_scene: PackedScene = preload("res://scenes/components/tile.tscn")

func _run():
	var selected = get_editor_interface().get_selection().get_selected_nodes();
	for node in selected:
		node.add_child(packed_scene.instantiate())
