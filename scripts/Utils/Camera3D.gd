extends Node3D

@export var target: Node3D
@export var speed: int = 1

@export var distance: float = 10
@export var max_distance: float = 20
@export var min_distance: float = 8

var mouse_sensitivity := 0.001
var pitch_input: float = 0
var twist_input: float = 0

func _ready():
	$TwistPivot/PitchPivot/Camera3D.position.z = distance
	
func _process(_delta):
	$TwistPivot.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x((pitch_input))
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, -0.7, -0.15)
	
	twist_input = 0.0
	pitch_input = 0.0
	
func _input(_event):
	if Input.is_action_just_pressed("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	var dist = %Camera3D.position.distance_to(Global.player_instance.position)
	if Input.is_action_just_pressed("scroll_wheel_up") and dist > min_distance:
		%Camera3D.position -= transform.basis.z

	elif Input.is_action_just_pressed("scroll_wheel_down") and dist < max_distance:
		%Camera3D.position += transform.basis.z
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = - event.relative.x * mouse_sensitivity
		pitch_input = - event.relative.y * mouse_sensitivity
