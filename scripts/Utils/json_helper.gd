class_name JSON_HELPER

static func load_json(file_path: String):
	if(FileAccess.file_exists(file_path)):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			printerr("Error reading file.")
	else:
		printerr("File does not exist!")

static func get_array_by_property(dict: Dictionary, property_name: String, property_value: Variant) -> Array[Dictionary]:
	var subset: Array[Dictionary]
	for item in dict.values():
		if item[property_name] == property_value:
			subset.append(item)
	return subset
	
static func get_item(dict: Dictionary, item_name: String):
	for item in dict.values():
		if item["name"] == item_name:
			return item["name"]
	return null
