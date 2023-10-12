class_name hex_grid
extends Node3D

@export var hex_tile_node: PackedScene
@export var hex_tiles: Array[Tile_Data] = []

@export var tile_size := 2.0
@export var height_variation := Vector2(-0.1, 0.1)

var pathfinder: path_finding = path_finding.new()
var tiles: Array[Tile] = []

func generate(grid_size: Vector2i):
	_generate_grid(grid_size)
	pathfinder.set_neighbours(5)
	pathfinder.generate_connections()
	
func get_tile(idx: int) -> Tile:
	return self.get_child(idx)
	
func get_open_tile() -> Tile:
	var subset = tiles.filter(func(tile: Tile): return !tile.is_used)
	return subset.pick_random()

func _generate_grid(grid_size: Vector2i):
	for x in grid_size.x:
		for y in grid_size.y:
			var tile_coordinates = Vector3(x * tile_size * cos(PI / 6), randf_range(height_variation.x, height_variation.y), y * tile_size)
			if x % 2 == 0: tile_coordinates.z += 0.5 * tile_size
				
			var tile = hex_tile_node.instantiate()
			tile.position = tile_coordinates
			tile.set_tile(_get_random_tile_resource())
			tiles.append(tile)
			add_child(tile)
	
func _get_random_tile_resource() -> Tile_Data: 
	var total_weight = 0.0
	for hex in hex_tiles:
		total_weight += hex.random_weight
		hex.accumulated_weight = total_weight
	
	var roll: float = randf_range(0, total_weight)
	for hex in hex_tiles:
		if hex.accumulated_weight > roll:
			return hex
			
	return hex_tiles[0]
