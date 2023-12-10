extends Node

var player_instance: Player = null
var scene_manager: SceneManager
var camera: Camera3D

var ui_root: Node

func game_over():
	print("You failed to deliver the items on time.")
