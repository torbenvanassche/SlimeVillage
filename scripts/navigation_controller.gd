extends Node3D

var pathfinder: path_finding = path_finding.new()

#setting this value higher can result in inconsistent neighbour calculations, set this cautiously
@export var max_distance = 1.1

# Called when the node enters the scene tree for the first time.
func _ready():
	_post_ready.call_deferred()
	
func _post_ready():		
	pathfinder.set_neighbours(max_distance)
	pathfinder.generate_connections()
