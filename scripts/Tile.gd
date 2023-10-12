class_name Tile
extends MeshInstance3D

@export var data: Tile_Data
var path_index: int

var path_controller: Node
var is_used: bool = false

var surface_point := Vector3()
var neighbours := []

@export var walkable_in_scene: bool

func _add_neighbour(tile: Tile):
	neighbours.append(tile)

func _ready():
	if data and !data.walkable:
		walkable_in_scene = data.walkable
		
	if walkable_in_scene:
		add_to_group("Walkable")
		path_controller = self
		while not path_controller.get("pathfinder"):
			path_controller = path_controller.get_parent()
		
		path_controller.pathfinder.add_node(self)
	
	$StaticBody3D.input_event.connect(_execute_internal)
	surface_point = self.global_position + Vector3(0, 1, 0)
	
	if data.material_override:
		(self as MeshInstance3D).material_override = data.material_override
	
func _execute_internal(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left") and walkable_in_scene and self != Global.player_instance.current_tile:
		path_controller.pathfinder.calc_path(Global.player_instance.current_tile.path_index, path_index)
		Global.player_instance.move()
		
func set_tile(new_data: Tile_Data):	
	self.data = new_data
	self.mesh = self.data.mesh
