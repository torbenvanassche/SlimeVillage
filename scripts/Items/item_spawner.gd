class_name TileTrigger
extends Node3D

var items: Array = []
@export var entry_tile: Tile

var area_transition_placeholder = preload("res://models/prototype/sm_icon_selection_ring_012.tscn")

func _ready():
	GlobalEvents.tile_destination_reached.connect(_internal_entered)
	var transition_placeholder = area_transition_placeholder.instantiate();
	entry_tile.add_child(transition_placeholder);
	
func _internal_entered(tile: Tile):
	if tile == entry_tile:
		_entered()
	
func _entered():
	#This function is abstract and must be overridden
	print("Not implemented!")
