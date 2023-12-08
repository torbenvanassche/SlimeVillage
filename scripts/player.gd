class_name Player
extends Node3D

var current_tile: Tile = null;
var inventory: Inventory = Inventory.new();

@export var click_navigator: ClickNavigator;
@export var wasd_navigator: DefaultNavigator;
		
func _ready():
	Global.player_instance = self
	
func set_position_to_current_tile(tile: Tile = current_tile):
	if !tile:
		print("No tile found to set position to, skipping...")
		return
	
	current_tile = tile
	get_parent().global_position = current_tile.surface_point
	
func find_location() -> Tile:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 2, 0))
	
	var result = space_state.intersect_ray(q)
	
	if result:
		return result.collider.get_parent() as Tile
		
	return null
	
func is_adjacent(tile1: Tile, tile2: Tile = current_tile):
	return tile1.neighbours.has(tile2) || tile2.neighbours.has(tile1)

func try_move(tile: Tile, move_near: bool = true):
	if move_near:
		var path = Global.scene_manager.active_scene.pathfinder.get_valid_path(current_tile, tile);
		tile.path_controller.pathfinder.set_path(path);
		click_navigator.move();
