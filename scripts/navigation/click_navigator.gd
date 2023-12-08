class_name ClickNavigator
extends Node3D

var destination_tile: Tile = null
var nav_index = 0

var timer: Timer = null
var progress: float = 0
var target: Player;

@export var move_delay: float = 0.25
@export var rotation_time: float = 0.1

var on_tile_destination_reached: Callable = Callable();

func move():	
	nav_index = 0
	if timer.is_stopped():
		timer.start()
	
func _ready():
	target = self.get_parent();
	
	timer = Timer.new()
	add_child(timer)
		
	timer.wait_time = move_delay
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
	if not target.current_tile:
		target.set_position_to_current_tile(target.find_location())
	
func _process(_delta):
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() != 0:
		progress = 1 - (timer.time_left / timer.wait_time)
		target.get_parent().position = target.current_tile.surface_point.lerp(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point, progress);
		
		if target.global_position.distance_to(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point) > 0.5:
			target.look_at(Global.scene_manager.active_scene.pathfinder.current_nav[nav_index].surface_point)
			
func _on_time():
	if Global.scene_manager.active_scene.pathfinder.current_nav.size() == 0:
		return
	
	if nav_index < Global.scene_manager.active_scene.pathfinder.current_nav.size() - 1:
		target.current_tile = Global.scene_manager.active_scene.pathfinder.current_nav[nav_index]
		nav_index += 1
	else: 
		target.current_tile = Global.scene_manager.active_scene.pathfinder.current_nav[nav_index]
		Global.scene_manager.active_scene.pathfinder.current_nav.clear()	
		
		if target.current_tile.trigger:
			target.current_tile.trigger.on_entered.emit();
		
		nav_index = 0
		timer.stop()
