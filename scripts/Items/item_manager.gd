extends Node

var data_file_path: String = "res://resources/items/item_database.json"
var _items: Dictionary;

func _init():	
	_items = JSON_HELPER.load_json(data_file_path)
	
func get_item(id: String):
	if _items.keys().find(id) != -1:
		var rv = _items[id];
		rv.id = id;
		return rv;
	printerr(id + " not found in the item database.")
	return null;
	
func get_by_property(prop: String, value: Variant, dict: Dictionary = _items):
	var a_items: Dictionary = {};
	for entry in dict.keys():
		if dict[entry].has(prop) && dict[entry][prop] == value:
			a_items[entry] = dict[entry];
			a_items[entry].id = entry;
	return a_items;

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://resources/items/scenes/" + item.scene_path
	if FileAccess.file_exists(path):
		return load(path)
	return null
	
func get_sprite(item: Dictionary) -> Texture:
	var path = "res://resources/items/sprites/" + item.sprite_path + ".png"
	if FileAccess.file_exists(path):
		return load(path)
	return null
	
func get_layout(item: Dictionary) -> Array[bool]:
	var result: Array[bool] = []
	for c in item.layout:
		result.append(bool(int(c)))
	return result;
	
func get_colors(item: Dictionary) -> Array[Color]:
	var colors: Array = item.colors;
	var output: Array[Color] = []
	for c in colors:
		output.append(Color(c));
	return output;
	
func get_components(item: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for component in item.components:
		result.append(get_item(component))
	return result
	
func get_craftables(components: Array[String], process: Helpers.CRAFT_METHOD):
	#TODO: Fix getting by property not workign for enum values
	var options = get_by_property("process", process, get_by_property("available", true));
	print(options)
	return options;
