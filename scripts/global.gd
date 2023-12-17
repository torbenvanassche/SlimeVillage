extends Node

var player_instance: Player = null
var manager: Manager
var camera: Camera3D

var ui_root: Node

enum NAV_STYLE 
{
	CLICK,
	WASD
}

func game_over():
	print("You failed to deliver the items on time.")
