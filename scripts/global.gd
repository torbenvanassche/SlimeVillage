extends Node

var player_instance: Player = null
@onready var camera: Camera3D = get_viewport().get_camera_3d()
var scene_manager: SceneManager

var ui_root: Node

func game_over():
	print("You failed to deliver the items on time.")
