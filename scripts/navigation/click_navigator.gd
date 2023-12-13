class_name ClickNavigator
extends Node3D

var destination_tile: Tile = null

var on_tile_destination_reached: Callable = Callable();
var target: Player;
	
func _ready():
	target = self.get_parent();
	
	if not target.current_tile:
		target.set_position_to_current_tile(target.find_location())
