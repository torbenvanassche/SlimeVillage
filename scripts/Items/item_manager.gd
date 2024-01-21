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
	
func get_available_items():
	var a_items: Dictionary = {};
	for entry in _items.keys():
		if _items[entry].available == true:
			a_items[_items[entry].id] = _items[entry];			
	return a_items;

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://resources/items/scenes/" + item.scene_path + ".tscn"
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
	
func craft(item: Dictionary, components: Array[Dictionary], process: Helpers.CRAFT_METHOD = Helpers.CRAFT_METHOD.CRAFT):
	if item.process == process:	
		return Helpers.arrays_have_same_content(get_components(item), components);
		
	return false;
