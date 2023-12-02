class_name Navigator
extends Node3D

var current_tile: Tile = null
var destination_tile: Tile = null
var nav_index = 0

var timer: Timer = null
var progress: float = 0
var target: Node3D;

@export var move_delay: float = 0.25
@export var rotation_time: float = 0.1

func move():
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() != 0:
		while !Global.scene_manager.active_scene.pathfinder.current_nav[-1].walkable_in_scene:
			Global.scene_manager.active_scene.pathfinder.current_nav.pop_back();
	
	nav_index = 0
	if timer.is_stopped():
		timer.start()
	
func ready():
	timer = Timer.new()
	add_child(timer)
		
	timer.wait_time = move_delay
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
	if not current_tile:
		set_position_to_current_tile(find_location())
	
func _process(_delta):
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() != 0:
		progress = 1 - (timer.time_left / timer.wait_time)
		target.get_parent().position = current_tile.surface_point.lerp(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point, progress);
		
		if target.global_position.distance_to(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point) > 0.5:
			target.look_at(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point)
			
func _on_time():
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() == 0:
		return
	
	if nav_index < Global.scene_manager.active_scene.pathfinder.current_nav.size() - 1:
		current_tile = Global.scene_manager.active_scene.pathfinder.current_nav[nav_index]
		nav_index += 1
	else: 
		current_tile = Global.scene_manager.active_scene.pathfinder.current_nav[nav_index]
		Global.scene_manager.active_scene.pathfinder.current_nav.clear()
		GlobalEvents.tile_destination_reached.emit(current_tile)
		
		nav_index = 0
		timer.stop()

func set_position_to_current_tile(tile: Tile = current_tile):
	if !tile:
		print("No tile found to set position to, skipping...")
		return
	
	current_tile = tile
	target.get_parent().global_position = current_tile.surface_point
	
func find_location() -> Tile:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 2, 0))
	
	var result = space_state.intersect_ray(q)
	
	if result:
		return result.collider.get_parent() as Tile
		
	return null

func try_move(tile: Tile, move_near: bool = true):
	if move_near:
		var path = Global.scene_manager.active_scene.pathfinder.get_valid_path(current_tile, tile);
		tile.path_controller.pathfinder.set_path(path);
		move();
	
	return tile.neighbours.has(current_tile);
