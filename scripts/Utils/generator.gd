class_name Grid
extends Node3D

var tile_size := 1.0
@export var entrance: Node3D = null;

var pathfinder: PathFinder = PathFinder.new();
var local_grid_size: Vector2i;

@export var save_name: String;

func generate(spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0):
	pathfinder.clear(false);
	
	pathfinder.set_tiles(Helpers.find_child_tiles(self));
	
	for i in range(item_spawn_tries):
		var item = Helpers.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			get_open_tile(Global.player_instance.current_tile).add_top(item);

	_init_pathfinder()
	
func _init_pathfinder():
	pathfinder.set_neighbours(1.1)
	pathfinder.generate_connections()

func get_tile(idx: int) -> TileBase:
	return self.get_child(idx)
	
func get_open_tile(exclusion: TileBase = null) -> TileBase:
	var subset = pathfinder.tiles_storage.filter(func(tile: TileBase): return tile.can_generate && tile != exclusion)
	return subset.pick_random()
	
func replace_tile(original: TileBase, replacement: TileBase) -> TileBase:
	replacement.position = original.position
	pathfinder.tiles_storage.erase(original)
	original.queue_free()
	
	add_child(replacement)
	pathfinder.tiles_storage.append(replacement)
	return replacement
