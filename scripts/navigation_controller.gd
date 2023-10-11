extends Node3D

var pathfinder: path_finding = path_finding.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_post_ready.call_deferred()
	
func _post_ready():		
	pathfinder.set_neighbours(5)
	pathfinder.generate_connections()
