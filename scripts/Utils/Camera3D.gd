extends Node3D

@export var target: Node3D

@export var distance: float = 10
@export var max_distance: float = 20
@export var min_distance: float = 8

var pitch_input: float = 0
var twist_input: float = 0

var mouse_position:Vector2

func _ready():
	%Camera3D.position.z = distance
	Global.camera = %Camera3D;
	
func _process(_delta):
	$TwistPivot.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x((pitch_input))
	$TwistPivot/PitchPivot.rotation.x = clamp($TwistPivot/PitchPivot.rotation.x, -0.7, -0.15)
	
	twist_input = 0.0
	pitch_input = 0.0
	
func _input(_event):
	if Input.is_action_just_pressed("rotate_camera"):
		mouse_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_viewport().warp_mouse(mouse_position)
		
	var dist = %Camera3D.position.distance_to(Global.player_instance.position)
	if Input.is_action_just_pressed("scroll_wheel_up") and dist > min_distance:
		%Camera3D.position -= transform.basis.z * Settings.camera_zoom_sensitivity;

	elif Input.is_action_just_pressed("scroll_wheel_down") and dist < max_distance:
		%Camera3D.position += transform.basis.z * Settings.camera_zoom_sensitivity;
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = - event.relative.x * Settings.camera_rotation_sensitivity;
		pitch_input = - event.relative.y * Settings.camera_rotation_sensitivity;
