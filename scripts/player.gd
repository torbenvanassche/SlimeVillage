class_name Player
extends Node3D

var timer: Timer = null
var nav_index = 0
var progress: float = 0

var current_tile: Tile = null
var destination_tile: Tile = null
var inventory: Inventory = Inventory.new()

@export var move_delay: float = 0.25
@export var rotation_time: float = 0.1

func move():
	nav_index = 0
	if timer.is_stopped():
		timer.start()
		
	look_to_direction()
		
func set_position_to_current_tile(tile: Tile = current_tile):
	current_tile = tile
	self.global_position = current_tile.surface_point

func _process(_delta):
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() != 0:
		progress = 1 - (timer.time_left / timer.wait_time)
		position = current_tile.surface_point.slerp(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point, progress)

func _ready():
	Global.player_instance = self
	
	timer = Timer.new()
	add_child(timer)
		
	timer.wait_time = move_delay
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
	if not current_tile:
		set_position_to_current_tile(find_location())
	
func find_location() -> Tile:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 5, 0), self.global_position - Vector3(0, 50, 0))
	
	var result = space_state.intersect_ray(q)
	if result:
		return result.collider.get_parent() as Tile
		
	return null
	
func look_to_direction():
	var tween := create_tween()
	tween.tween_method(_tween_rotation, 0.0, 1.0, rotation_time)

func _tween_rotation(p):
	var lookat_target = Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point
	var lookat_transform = $mesh.global_transform.looking_at(lookat_target, Vector3.UP)
	var initial_basis = $mesh.global_transform.basis
	
	$mesh.global_transform.basis = initial_basis.slerp(lookat_transform.basis, p)
	$mesh.rotate_y(deg_to_rad(180))

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
