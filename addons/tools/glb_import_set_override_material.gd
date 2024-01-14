@tool
extends EditorScript

var material: String = "res://materials/polygon/polygon_fantasy.tres"

func _run():
	var interface = get_editor_interface();
	var selected_paths = interface.get_selected_paths();
	var cfg = ConfigFile.new();
	
	for path in selected_paths:
		if path.get_extension() == "glb":
			var config_path = path + ".import";
			cfg.load(config_path)
			
			var ss = cfg.get_section_keys("params")
			var s = cfg.get_value("params", "_subresources");
	
			for mat in s.materials:
				s.materials[mat]["use_external/enabled"] = true;
				s.materials[mat]["use_external/path"] = material;
				
			cfg.save(config_path)
