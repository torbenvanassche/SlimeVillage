class_name TileBase
extends Node3D

var path_index: int

var surface_point := Vector3()

@export var neighbours_custom = false;
@export var neighbours: Array[TileBase] = []
var side_count: int = 4

@export var walkable_in_scene: bool;
var navigation_weight: int = 0

func _add_neighbour(tile: TileBase):
	neighbours.append(tile)

func _ready():	
	find_surface()	
	
func find_surface():
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(self.global_position  + Vector3(0, 1, 0), self.global_position - Vector3(0, 1, 0))
	
	var result = space_state.intersect_ray(q)
	if result:
		surface_point = result.position
