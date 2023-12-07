class_name Grid
extends Node3D

var ground_tile: PackedScene = preload("res://scenes/tiles/tile_full_texture.tscn")

@export var tile_options: Array[Tile_Data] = []

@export var tile_size := 1.0
@export var height_variation := Vector2(-0.1, 0.1)

var pathfinder: path_finding = path_finding.new();
var local_grid_size: Vector2i;

func generate(grid_size: Vector2i, spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0, clear: bool = true):
	if(clear):
		pathfinder.clear(true);
	
	_generate_grid(grid_size)
	local_grid_size = grid_size;
	
	for i in range(item_spawn_tries):
		var item = Helpers.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			get_open_tile(Global.player_instance.navigator.current_tile).add_top(item);

	_init_pathfinder()
	
func _generate_grid(grid_size: Vector2i):
	for x in grid_size.x:
		for y in grid_size.y:
			var newTile: Tile = ground_tile.instantiate()
			newTile.position = Vector3(x * tile_size, randf_range(height_variation.x, height_variation.y), y * tile_size)
			self.add_child(newTile)
	
func _init_pathfinder():
	pathfinder.set_neighbours(1.1)
	pathfinder.generate_connections()

func get_tile(idx: int) -> Tile:
	return self.get_child(idx)
	
func get_open_tile(exclusion: Tile = null) -> Tile:
	var subset = pathfinder.hex_tiles_storage.filter(func(tile: Tile): return !tile.is_used && tile != exclusion)
	return subset.pick_random()
	
func replace_tile(original: Tile, replacement: Tile) -> Tile:
	replacement.position = original.position
	pathfinder.hex_tiles_storage.erase(original)
	original.queue_free()
	
	add_child(replacement)
	pathfinder.hex_tiles_storage.append(replacement)
	return replacement

func get_outer_ring() -> Array[Tile]:
	var tileArr: Array[Tile] = [];
	for i in range(pathfinder.hex_tiles_storage.size()):
		if i < local_grid_size.x || i % local_grid_size.x == 0 || i % local_grid_size.x == local_grid_size.x - 1 || i > pathfinder.hex_tiles_storage.size() - local_grid_size.x:
			if !tileArr.has(pathfinder.hex_tiles_storage[i]) && pathfinder.hex_tiles_storage[i].walkable_in_scene:
				tileArr.append(pathfinder.hex_tiles_storage[i])
	return tileArr;
