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
@export var rotation_time: float = 0.1;

var move_tween: Tween;
var is_moving := false;
		
func _ready():
	Global.player_instance = self
	inventory_ui.controller = inventory;
	animator.speed_scale = (1 / (move_delay + 0.1));
	
	Settings.input_mode = input_mode;
	read_input_mode();
	
func read_input_mode():
	match Settings.input_mode:
		Global.NAV_STYLE.CLICK:
			wasd_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			click_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
		Global.NAV_STYLE.WASD:
			click_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			wasd_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
	
func move(): 
	_move_next()
	
func _move_next(idx: int = 0):		
	if !animator.is_playing():
		animator.play("hop");
		
	if !is_moving:
		move_tween = get_tree().create_tween();
		is_moving = true;
		
	for mover in Global.path_finder.current_nav:
		move_tween.chain().tween_property(self, "global_position", mover.surface_point, move_delay).set_trans(Tween.TRANS_QUAD).set_delay(0.05);
	move_tween.step_finished.connect(_set_to_index)
	move_tween.finished.connect(animator.stop);
	move_tween.finished.connect(_set_to_index);
	move_tween.finished.connect(func(): is_moving = false);
		
func try_move(tile: TileBase) -> bool:
	var path = Global.path_finder.get_valid_path(current_tile, tile);
	if path.size() != 0:
		if !is_moving:
			Global.path_finder.set_path(path);
		else:
			return false;
		move();
		return true;
	return false;
		
func _set_to_index(idx: int = -1):
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
