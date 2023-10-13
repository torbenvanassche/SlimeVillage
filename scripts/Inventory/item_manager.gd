extends Node

var data_file_path: String = "res://resources/items/item_database.json"
var items = {}

func _ready():	
	items = JSON_HELPER.load_json(data_file_path)
	
func get_item_by_name(string: String) -> Dictionary:
	return items.filter(func(x): return x.name == string)[0]

func rand_item_weighted(arr: Array, fail_weight: int = 0):
	if arr.size() == 0:
		return null
	
	var total_weight = 0
	for item in arr:
		total_weight += item["random_weight"]
		item.accumulated_weight = total_weight
	
	var roll: int = randi_range(-fail_weight, total_weight)
		
	if roll < 0:
		return null
	
	for item in arr:
		if item.accumulated_weight >= roll:
			return item
	return null

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://resources/items/scenes/" + item["scene_path"] + ".tscn"
	if FileAccess.file_exists(path):
		return load(path)
	return null
	
func get_sprite(item: Dictionary) -> Texture:
	var path = "res://resources/items/sprites/" + item["sprite_path"] + ".tres"
	if FileAccess.file_exists(path):
		return load(path)
	return null
