class_name NavigationController
extends Node3D

var pathfinder: PathFinder = PathFinder.new()
@export var entrance: Node3D = null;

#setting this value higher can result in inconsistent neighbour calculations, set this cautiously
@export var max_distance = 1.1

# Called when the node enters the scene tree for the first time.
func on_enable():
	pathfinder.set_neighbours(max_distance)
	pathfinder.generate_connections()
