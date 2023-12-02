class_name Navigator
extends Node

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
	
func _ready():
	timer = Timer.new()
	add_child(timer)
		
	timer.wait_time = move_delay
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
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
