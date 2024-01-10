@tool
extends EditorScript

func _run():
	var interface = get_editor_interface();
	var selected_paths = interface.get_selected_paths();
	for path in selected_paths:
		var data = load(path)
		var selected_nodes = interface.get_selection().get_selected_nodes();
			
		for node in selected_nodes:		
			if data is PackedScene:
				var instance = data.instantiate();
				node.add_child(instance)
				instance.owner = get_scene()
			elif data is GDScript:
				node.set_script(data)
