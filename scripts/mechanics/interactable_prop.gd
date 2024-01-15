extends Node

func _ready():
	$StaticBody3D.input_event.connect(execute)
	
func redraw():
	pass

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("mouse_left"):
		pass
