class_name path_finding
extends Node

var current_nav = []
var tiles_storage: Array[Tile] = []
var path_finder = AStar2D.new()	
var max_distance = 0;
	
func add_node(tile: Tile, update_navigation = false):
	if(!tiles_storage.has(tile)):
		tiles_storage.append(tile);
		
		if(update_navigation):
			set_neighbours();
			generate_connections();		
		
func remove_node(tile: Tile, update_navigation = false):
	if(tiles_storage.has(tile)):
		tiles_storage.erase(tile);
		
	if(update_navigation):
		set_neighbours();
		generate_connections();	
		
func set_tiles(tileArr: Array[Tile]):
	tiles_storage = tileArr;
	
func clear_connections():
	for tile in tiles_storage:
		tile.neighbours.clear()
		
func clear(delete_tiles: bool):
	path_finder.clear()
	clear_connections();
	
	if delete_tiles:
		for tile in tiles_storage:
			tile.queue_free()
		
	
func get_random_tile(): 
	return tiles_storage[randi_range(0, tiles_storage.size() - 1)]
	
func set_neighbours(distance: float = max_distance):
	max_distance = distance;
	
	for current_tile in tiles_storage:
		current_tile.neighbours.clear()
		for potential_neighbour in tiles_storage:
			if current_tile != potential_neighbour:
				var dist = Vector2(current_tile.global_position.x, current_tile.global_position.z).distance_squared_to(Vector2(potential_neighbour.global_position.x, potential_neighbour.global_position.z))
				if dist < max_distance:
					current_tile._add_neighbour(potential_neighbour)
					
func generate_connections():
	for tile in tiles_storage:
		if tile.walkable_in_scene:
			tile.path_index = path_finder.get_point_count()		
			path_finder.add_point(tile.path_index, Vector2(tile.global_position.x, tile.global_position.z), tile.navigation_weight)
		
	for tile in tiles_storage:
		for connected_tile in tile.neighbours:
			if connected_tile.walkable_in_scene && tile.walkable_in_scene:
				path_finder.connect_points(tile.path_index, connected_tile.path_index)
			
func repath():
	if current_nav.size() != 0:
		calc_path(Global.player_instance.current_tile.path_index, current_nav[current_nav.size() - 1].path_index)

func calc_path(from: int, to: int):	
	current_nav.clear()
	
	for t in path_finder.get_id_path(from, to):
		current_nav.append(tiles_storage.filter(func(x): return x.path_index == t)[0])
	current_nav.pop_front()
	
func get_valid_path(start: Tile, end: Tile) -> Array[Tile]:
	var closest_path: PackedInt64Array = []
	if end && start.walkable_in_scene:
		if end && end.walkable_in_scene:
			return _indices_to_tiles(path_finder.get_id_path(start.path_index, end.path_index));
		
		for n in end.neighbours:
			if n.walkable_in_scene:
				var path = path_finder.get_id_path(start.path_index, n.path_index);
				if path.size() < closest_path.size() || closest_path.size() == 0:
					closest_path = path;
	return _indices_to_tiles(closest_path);
	
func _indices_to_tiles(arr: PackedInt64Array) -> Array[Tile]:
	var path: Array[Tile] = []
	
	for t in arr:
		path.append(tiles_storage.filter(func(x): return x.path_index == t)[0])
	path.pop_front()
	return path;
	
func set_path(arr: Array[Tile]):
	current_nav = arr;
