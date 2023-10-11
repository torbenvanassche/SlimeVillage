class_name Player
extends MeshInstance3D

var timer: Timer = null
var nav_index = 0
var progress: float = 0

@export var current_tile: Tile = null

var inventory: Inventory = Inventory.new()

func move():
	nav_index = 0
	if timer.is_stopped():
		timer.start()
		
func set_position_to_current_tile(tile: Tile):
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
		
	timer.wait_time = 0.25
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
	if not current_tile:
		current_tile = find_location()
		
	GlobalEvents.resource_location_interaction.connect(func(x): print(x))
	
func find_location() -> Tile:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 5, 0), self.global_position - Vector3(0, 50, 0))
	
	var result = space_state.intersect_ray(q)
	if result.collider.get_parent() is Tile:
		return result.collider.get_parent()
	else:
		return null

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
