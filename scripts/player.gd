class_name Player
extends Node3D

var current_tile: TileBase = null;

@export var inventory: Inventory;
@export var inventory_ui: InventoryUI;
@export var animator: AnimationPlayer;
var animation_delay = 0.2

@export var click_navigator: ClickNavigator;
@export var wasd_navigator: DefaultNavigator;
@export var input_mode: Global.NAV_STYLE = Settings.input_mode;

@export var move_delay: float = 0.5
@export var rotation_time: float = 0.01;

var move_tween: Tween;
var is_moving := false;
var buffered_target_tile: TileBase
		
func _ready():
	Global.player_instance = self
	inventory_ui.controller = inventory;
	animator.speed_scale = (1 / (move_delay + 0.1));
	
	Settings.input_mode = input_mode;
	read_input_mode();

func _process(_delta):
	#if we're not moving but have a path, start moving
	if !is_moving and ( Global.path_finder.current_nav.size() > 0 or buffered_target_tile ):
		move()
	
func read_input_mode():
	match Settings.input_mode:
		Global.NAV_STYLE.CLICK:
			wasd_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			click_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
		Global.NAV_STYLE.WASD:
			click_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			wasd_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
	
func move(): 
	if buffered_target_tile:
		is_moving = false
		try_move(buffered_target_tile)
	
	if  Global.path_finder.current_nav.size() < 1 and not buffered_target_tile:
		is_moving = false
		return
	
	_move_next()
	#if not is_moving and buffered_target_tile:
	#	try_move(buffered_target_tile) #creates new path
	
func _move_next():
	is_moving = true
	var next_target = Global.path_finder.current_nav.pop_front()
	print("position: " + str(get_parent().global_position) + " target: " + str(next_target.surface_point) )
	move_tween = get_tree().create_tween();
	move_tween.tween_property(self.get_parent(), "global_position", next_target.surface_point, move_delay).set_trans(Tween.TRANS_QUAD).set_delay(0.05);
	move_tween.finished.connect(_update_current_tile.bind(next_target))
	move_tween.finished.connect(move)
	pass

func _update_current_tile(new_tile:TileBase):
	current_tile = new_tile

func try_move(tile: TileBase) -> bool:
	var path = Global.path_finder.get_valid_path(current_tile, tile);
	if path.size() != 0:
		if is_moving:
			buffered_target_tile = tile
			print("Add buffered_target " + str(buffered_target_tile.surface_point))
		else:
			buffered_target_tile = null
			Global.path_finder.set_path(path);
		return true;
	return false;
		
func _set_to_index(idx: int = -1):
	if idx > 0:
		idx = (int)(idx / 2);
	current_tile = Global.path_finder.current_nav[idx]

func set_position_to_current_tile(tile: TileBase = current_tile):
	if !tile:
		print("No tile found to set position to, skipping...")
		return
	
	current_tile = tile
	tile.find_surface()
	get_parent().global_position = current_tile.surface_point
	
func find_location() -> TileBase:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 2, 0))
	
	var result = space_state.intersect_ray(q)
	
	if result:
		return result.collider as TileBase
		
	return null
	
func is_adjacent(tile1: TileBase, tile2: TileBase = current_tile):
	return tile1.neighbours.has(tile2) || tile2.neighbours.has(tile1)
