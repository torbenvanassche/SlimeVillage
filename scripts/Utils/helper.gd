class_name Helpers
extends Node

enum CRAFT_METHOD 
{
	CRAFT,
	GRIND,
	ALCHEMY,
	FORGE
}

static func randarr_range(arr: Array):
	return arr[randi_range(0, arr.size() - 1)]

static func arrays_have_same_content(array1: Array, array2: Array):
	if array1.size() != array2.size(): 
		return false
	for item in array1:
		if !array2.has(item): 
			return false
		if array1.count(item) != array2.count(item): 
			return false
	return true

static func rand_item_weighted(arr: Array, fail_weight: int = 0):
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

static func write_to_file(node: Node, file_name: String):
	if(file_name != "" && FileAccess.file_exists("res://procedural_storage/" + file_name + ".tscn")):
		var packed_scene = PackedScene.new()
		packed_scene.pack(node)
		ResourceSaver.save(packed_scene, "res://procedural_storage/" + file_name + ".tscn")
		return true;
	return false;

static func read_from_file(file_name: String) -> PackedScene:
	if(file_name != ""):
		if ResourceLoader.exists("res://procedural_storage/" + file_name + ".tscn"):
			var scene = ResourceLoader.load("res://procedural_storage/" + file_name + ".tscn")
			return scene;
	return null;
			
static func just_pressed_from_list(input_arr: Array[String]):
	var any_valid = false;
	for input in input_arr:
		if Input.is_action_just_pressed(input):
			any_valid = true;
	return any_valid;
	
static func pressed_from_list(input_arr: Array[String]):
	var any_valid = false;
	for input in input_arr:
		if Input.is_action_pressed(input):
			any_valid = true;
	return any_valid;
	
static func find_child_tiles(node: Node) -> Array[TileBase]:
	var tile_nodes: Array[TileBase] = []
	for child in node.get_children():
		if child is TileBase:
			tile_nodes.append(child)
			if child.get_child_count() > 0:
				tile_nodes.append_array(find_child_tiles(child))
	return tile_nodes
