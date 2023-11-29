class_name path_finding
extends Node

var current_nav = []
var hex_tiles_storage: Array[Tile] = []
var path_finder = AStar2D.new()	
var max_distance = 0;
	
func add_node(tile: Tile):
	if(!hex_tiles_storage.has(tile)):
		hex_tiles_storage.append(tile);
		
		set_neighbours();
		generate_connections();		
		
func remove_node(tile: Tile):
	if(hex_tiles_storage.has(tile)):
		hex_tiles_storage.erase(tile);
		
	set_neighbours();
	generate_connections();	
	
func clear_connections():
	path_finder.clear()
	for tile in hex_tiles_storage:
		tile.neighbours.clear()
		
func clear(delete_tiles: bool):
	clear_connections();
	
	if delete_tiles:
		for tile in hex_tiles_storage:
			tile.queue_free()
		
	
func get_random_tile(): 
	return hex_tiles_storage[randi_range(0, hex_tiles_storage.size() - 1)]
	
func set_neighbours(distance: float = max_distance):
	max_distance = distance;
	
	for current_tile in hex_tiles_storage:
		if current_tile.walkable_in_scene:
			current_tile.neighbours.clear()
			for potential_neighbour in hex_tiles_storage:
				if current_tile != potential_neighbour and potential_neighbour.walkable_in_scene:
					var dist = Vector2(current_tile.global_position.x, current_tile.global_position.z).distance_squared_to(Vector2(potential_neighbour.global_position.x, potential_neighbour.global_position.z))
					if dist < max_distance:
						current_tile._add_neighbour(potential_neighbour)
					
func generate_connections():
	for tile in hex_tiles_storage:
		tile.path_index = path_finder.get_point_count()		
		path_finder.add_point(tile.path_index, Vector2(tile.global_position.x, tile.global_position.z), tile.navigation_weight)
		
	for tile in hex_tiles_storage:
		for connected_tile in tile.neighbours:
			path_finder.connect_points(tile.path_index, connected_tile.path_index)
			
func repath():
	if current_nav.size() != 0:
		calc_path(Global.player_instance.current_tile.path_index, current_nav[current_nav.size() - 1].path_index)

func calc_path(from: int, to: int):	
	current_nav.clear()
	
	for t in path_finder.get_id_path(from, to):
		current_nav.append(hex_tiles_storage.filter(func(x): return x.path_index == t)[0])
	current_nav.pop_front()
