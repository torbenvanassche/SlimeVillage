extends Node

var data_file_path: String = "res://resources/items/item_database.json"
var items: Dictionary;

func _ready():	
	items = JSON_HELPER.load_json(data_file_path)
	
func get_item_by_name(string: String) -> Dictionary:
	var filter = items.values().filter(func(x): x["name"] == string);
	if filter.size() == 1:
		return filter[0]
		
	printerr(string + " does not exist in the itemdatabase.")
	return {} 

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://resources/items/scenes/" + item["scene_path"] + ".tscn"
	if FileAccess.file_exists(path):
		return load(path)
	return null
	
func get_sprite(item: Dictionary) -> Texture:
	var path = "res://resources/items/sprites/" + item["sprite_path"] + ".png"
	if FileAccess.file_exists(path):
		return load(path)
	return null
	
func get_colors(item: Dictionary) -> Array[Color]:
	var colors: Array = item["Colors"];
	var output: Array[Color] = []
	for c in colors:
		output.append(Color(c));
	return output;
	
func get_components(item: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for component in item["components"]:
		result.append(get_item_by_name(component))
	return result
	
func craft(item: Dictionary, components: Array[Dictionary], process: Helpers.CRAFT_METHOD = Helpers.CRAFT_METHOD.CRAFT):
	if item["Process"] == process:	
		return Helpers.arrays_have_same_content(get_components(item), components);
		
	return false;
