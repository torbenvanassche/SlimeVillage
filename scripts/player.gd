class_name Player
extends Node3D

var current_tile: Tile = null;

@export var inventory: Inventory;
@export var inventory_ui: InventoryUI;

@export var click_navigator: ClickNavigator;
@export var wasd_navigator: DefaultNavigator;
@export var input_mode: Global.NAV_STYLE = Settings.input_mode;

var timer: Timer = null
var progress: float = 0

@export var move_delay: float = 0.25
@export var rotation_time: float = 0.1
var nav_index = 0
		
func _ready():
	Global.player_instance = self
	inventory.init(inventory_ui);
	
	Settings.input_mode = input_mode;
	read_input_mode();
	
	timer = Timer.new()
	add_child(timer)
		
	timer.wait_time = move_delay
	timer.one_shot = false
	timer.timeout.connect(_on_time)
	
func read_input_mode():
	match Settings.input_mode:
		Global.NAV_STYLE.CLICK:
			wasd_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			click_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
		Global.NAV_STYLE.WASD:
			click_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			wasd_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
	
func _on_time():
	if Global.manager.active_scene.pathfinder.current_nav.size() == 0:
		return
	
	if nav_index < Global.manager.active_scene.pathfinder.current_nav.size() - 1:
		current_tile = Global.manager.active_scene.pathfinder.current_nav[nav_index]
		nav_index += 1
	else: 
		current_tile = Global.manager.active_scene.pathfinder.current_nav[nav_index]
		Global.manager.active_scene.pathfinder.current_nav.clear()	
		
		wasd_navigator.can_move = true;
		
		if current_tile.trigger:
			current_tile.trigger.on_entered.emit();
		
		nav_index = 0
		timer.stop()
	
func move():	
	nav_index = 0
	if timer.is_stopped():
		timer.start()
	
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

func try_move(tile: Tile, move_near: bool = true) -> bool:
	if move_near:
		var path = Global.manager.active_scene.pathfinder.get_valid_path(current_tile, tile);
		if path.size() != 0:
			tile.path_controller.pathfinder.set_path(path);
			move();
			
		return path.size() != 0
	return true;

func _process(_delta):
	if Global.manager.active_scene.pathfinder.current_nav.size() != 0:
		progress = 1 - (timer.time_left / timer.wait_time)
		get_parent().position = current_tile.surface_point.lerp(Global.manager.active_scene.pathfinder.current_nav[nav_index].surface_point, progress);
		
		if global_position.distance_to(Global.manager.active_scene.pathfinder.current_nav[nav_index].surface_point) > 0.5:
			self.look_at(Global.manager.active_scene.pathfinder.current_nav[nav_index].surface_point)
