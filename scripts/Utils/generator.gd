class_name Grid
extends Node3D

@export var entrance: Node3D = null;
@export var save_name: String;

var local_grid_size: Vector2i;
var tile_size := 1.0

func generate(spawnables: Dictionary = {}, item_spawn_tries = 0, spawn_fail_weight = 0):	
	for i in range(item_spawn_tries):
		var item = Helpers.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			get_open_tile(Global.player_instance.current_tile).add_top(item);

func get_tile(idx: int) -> TileBase:
	return self.get_child(idx)
	
func get_open_tile(exclusion: TileBase = null) -> TileBase:
	var subset = Global.path_finder.tiles_storage.filter(func(tile: TileBase): return tile.can_generate && tile != exclusion)
	return subset.pick_random()
	
func replace_tile(original: TileBase, replacement: TileBase) -> TileBase:
	replacement.position = original.position
	Global.path_finder.tiles_storage.erase(original)
	original.queue_free()
	
	add_child(replacement)
	Global.path_finder.tiles_storage.append(replacement)
	return replacement
