@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "json.item_importer"
	
func _get_visible_name():
	return "Item importer"
	
func _get_recognized_extensions():
	return ["json"]
	
func _get_save_extension():
	return "json"
	
func _get_resource_type():
	return "JSON"

func _get_preset_count() -> int:
	return Presets.size()

func _get_preset_name(preset : int) -> String:
	match preset:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"


func _get_import_options(path : String, preset_index : int) -> Array[Dictionary]:
	return []
	
func _get_option_visibility(path, option_name, options):
	return true
	
func _get_priority():
	return 1
	
func _get_import_order():
	return 0
	
func _create_enum(keys):
	var content = "class_name item_database \nenum id { ";
	for key in keys:
		content += key + ", "
	content += "}"
	return content;
	
func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
		
	var json = JSON.new();
	json.parse(file.get_as_text())	
	var keys = json.get_data().keys();
	
	var base_dir = source_file.get_base_dir()
	var content = _create_enum(keys);
	
	var out_file = FileAccess.open(base_dir + "/item_database_ids.gd", FileAccess.WRITE)
	out_file.store_string(content);
	out_file.close()
	
	EditorInterface.get_resource_filesystem().scan();
	
	return OK;
