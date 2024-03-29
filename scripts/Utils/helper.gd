class_name Helpers
extends Node

enum CRAFT_METHOD 
{
	CRAFT,
	GRIND,
	ALCHEMY,
	FORGE
}
	
static func convert_craft_method(value: int):
	return CRAFT_METHOD.keys()[value];

static func arrays_have_same_content(array1: Array, array2: Array):	
	if array1.size() != array2.size(): 
		return false
	for item in array1:
		if !array2.has(item): 
			return false
		if array1.count(item) != array2.count(item): 
			return false
	return true

static func rand_item_weighted(dict: Dictionary, fail_weight: int = 0):
	if dict.keys().size() == 0:
		return null
	
	var total_weight = 0
	for item in dict.keys():
		total_weight += dict[item].random_weight
		dict[item].accumulated_weight = total_weight
	
	var roll: int = randi_range(-fail_weight, total_weight)
		
	if roll < 0:
		return null
	
	for item in dict.keys():
		if dict[item].accumulated_weight >= roll:
			return dict[item]
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

static func convert_to_2D(data: Array[Variant] = [true], column_count: int = 1):
	var shape_data: Array = [];	
	var curr_arr: Array = []
	shape_data.clear()
		
	for x in range(data.size()):
		curr_arr.append(data[x])
		if x % column_count == column_count - 1:
			shape_data.append(curr_arr.duplicate());
			curr_arr.clear();
	return shape_data;
	
static func flatten_hierarchy(node: Node, internal: bool = false) -> Array[Node]:
	var arr: Array[Node] = [];
	for c in node.get_children(internal):
		arr.append(c)
		if c.get_child_count() > 0:
			arr.append_array(flatten_hierarchy(c));
	return arr;
