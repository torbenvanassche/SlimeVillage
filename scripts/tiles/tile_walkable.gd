extends TileInteractable

func _ready():
	super()
	Global.path_finder.add_node(self)
	initialize()

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("mouse_left") and walkable_in_scene && self != Global.player_instance.current_tile && Settings.input_mode == Global.NAV_STYLE.CLICK:
		Global.player_instance.try_move(self)
