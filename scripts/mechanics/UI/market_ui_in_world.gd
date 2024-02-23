extends Node

@export var _poster_packed: Array[PackedScene]

func get_poster():
	return _poster_packed.pick_random().instantiate();
