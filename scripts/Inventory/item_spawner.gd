class_name ItemSpawner
extends Node

@export var items: Array = []
@export var entry_tile: Tile

func _ready():
	GlobalEvents.tile_destination_reached.connect(_internal_entered)
	
func _internal_entered(tile: Tile):
	if tile == entry_tile:
		_entered()
	
func _entered():
	#This function is abstract and must be overridden
	print("Not implemented!")
