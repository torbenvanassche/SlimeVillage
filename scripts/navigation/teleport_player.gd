extends Node

@export var destination: TileBase;

func execute(options: Dictionary = {}):
	options.player.set_position_to_current_tile(destination);
