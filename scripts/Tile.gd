class_name Tile
extends Node3D

var path_index: int

var path_controller: Node
var is_used: bool = false

var surface_point := Vector3()
var neighbours := []
var side_count: int = 4

@export var trigger: Triggerable;
@export var tile_data: Tile_Data: 
	set(value): 
		tile_data = value
		set_tile(tile_data)

@export var walkable_in_scene: bool;
			
var navigation_weight: int = 0

func _add_neighbour(tile: Tile):
	neighbours.append(tile)

func _ready():			
	path_controller = self
	while not path_controller.get("pathfinder"):
		path_controller = path_controller.get_parent()
		
	path_controller.pathfinder.add_node(self)
	
	if walkable_in_scene:
		$StaticBody3D.input_event.connect(_execute_internal)
	$StaticBody3D.set_meta("tile", self)
	
	find_surface()	
	
	set_tile(tile_data)
	
func find_surface():
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 1, 0))
	
	var result = space_state.intersect_ray(q)
	if result:
		surface_point = result.position
	
func _execute_internal(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left") and walkable_in_scene and self != Global.player_instance.current_tile:
		Global.player_instance.try_move(self)
		
func add_top(item_data: Dictionary):
	var spawned = ItemManager.get_scene(item_data).instantiate()
	if spawned is Interactable:
		spawned.initialize(item_data);
			
		add_child(spawned)
		walkable_in_scene = false
		is_used = true
		
func set_tile(data: Tile_Data):
	if !data: 
		return
	
	if !data.walkable:
		walkable_in_scene = data.walkable;
		
	var tile = get_node_or_null("SM_Generic_Ground_02/SM_Generic_Ground_02");
	if tile && data.ground_material:
		tile.set_material_override(data.ground_material);
		
	navigation_weight = data.navigation_weight
	
	if data.randomize_rotation:
		self.rotate_y(deg_to_rad(randi_range(0, side_count) * 360.0 / side_count))

