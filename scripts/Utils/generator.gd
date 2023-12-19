class_name Grid
extends Node3D

var tile_size := 1.0
@export var entrance_tile: Node3D = null;

var pathfinder: path_finding = path_finding.new();
var local_grid_size: Vector2i;

@export var save_name: String;

func generate(spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0):
	pathfinder.clear(false);
	
	pathfinder.set_tiles(Helpers.find_child_tiles(self));
	
	Global.player_instance.current_tile = entrance_tile;
	
	for i in range(item_spawn_tries):
		var item = Helpers.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			get_open_tile(Global.player_instance.current_tile).add_top(item);

	_init_pathfinder()
	
func _init_pathfinder():
	pathfinder.set_neighbours(1.1)
	pathfinder.generate_connections()

func get_tile(idx: int) -> Tile:
	return self.get_child(idx)
	
func get_open_tile(exclusion: Tile = null) -> Tile:
	var subset = pathfinder.tiles_storage.filter(func(tile: Tile): return tile.can_generate && tile != exclusion)
	return subset.pick_random()
	
func replace_tile(original: Tile, replacement: Tile) -> Tile:
	replacement.position = original.position
	pathfinder.tiles_storage.erase(original)
	original.queue_free()
	
	add_child(replacement)
	pathfinder.tiles_storage.append(replacement)
	return replacement
