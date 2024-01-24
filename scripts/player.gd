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

var nav_index = 0
		
func _ready():
	Global.player_instance = self
	inventory_ui.controller = inventory;
	animator.speed_scale = 1 / move_delay;
	
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
	_move_next(0, Global.path_finder.current_nav)
	
func _move_next(idx: int, path: Array[TileBase]):
	animator.play("hop");
	var tween := get_tree().create_tween();
	tween.tween_property(self.get_parent(), "global_position", path[idx].surface_point, move_delay);
	tween.parallel().tween_method(self.look_at.bind(Vector3.UP), global_transform.origin, path[idx].surface_point, rotation_time).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): current_tile = path[idx])
	
	if idx < path.size() - 1:
		tween.tween_callback(_move_next.bind(idx + 1, path))
	else:
		tween.finished.connect(func(): current_tile = Global.path_finder.current_nav[-1])
		tween.finished.connect(animator.stop)

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

func try_move(tile: TileBase) -> bool:
	var path = Global.path_finder.get_valid_path(current_tile, tile);
	if path.size() != 0:
		Global.path_finder.set_path(path);
		move();
		return true;
	return false;
