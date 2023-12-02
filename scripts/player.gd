class_name Player
extends Node3D

var inventory: Inventory = Inventory.new();

@export var navigator: Navigator;
		
func _ready():
	Global.player_instance = self
	navigator.target = self;
	
	if not navigator.current_tile:
		set_position_to_current_tile(find_location())
		
func set_position_to_current_tile(tile: Tile = navigator.current_tile):
	if !tile:
		print("No tile found to set position to, skipping...")
		return
	
	navigator.current_tile = tile
	self.get_parent().global_position = navigator.current_tile.surface_point
	
func find_location() -> Tile:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 2, 0))
	
	var result = space_state.intersect_ray(q)
	
	if result:
		return result.collider.get_parent() as Tile
		
	return null
	
func try_move(tile: Tile, move_near: bool = true):
	if move_near:
		var path = Global.scene_manager.active_scene.pathfinder.get_valid_path(navigator.current_tile, tile);
		tile.path_controller.pathfinder.set_path(path);
		navigator.move();
	
	return tile.neighbours.has(navigator.current_tile);
