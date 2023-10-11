extends Node

var data_file_path: String = "res://resources/items/item_database.json"
var items = {}

func _ready():	
	items = JSON_HELPER.load_json(data_file_path)
	
func get_item_by_name(string: String) -> Dictionary:
	return items.filter(func(x): return x.name == string)[0]

func rand_item_weighted(arr: Array):
	var total_weight = 0.0
	for item in arr:
		total_weight += item["random_weight"]
		item.accumulated_weight = total_weight
	
	var roll: float = randf_range(0, total_weight)
	for item in arr:
		if item.accumulated_weight > roll:
			return item
			
	return items[0]
