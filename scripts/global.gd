extends Node

var player_instance: Player = null
@onready var camera: Camera3D = get_viewport().get_camera_3d()
var scene_manager: SceneManager

var ui_root: Node

#UI signals
signal event_context_menu_open(dict: Dictionary, r: Rect2i)

func _ready():
	event_context_menu_open.connect(show)
	
func show(dict: Dictionary, r: Rect2i):
	ContextMenu.show_menu(dict, r)

func game_over():
	print("You failed to deliver the items on time.")
