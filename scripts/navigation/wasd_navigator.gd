class_name DefaultNavigator
extends Node3D

var input_checks: Array[String] = ["move_left", "move_right", "move_back", "move_forward"];

func _process(delta):
	var any_valid = false;
	for input in input_checks:
		if Input.is_action_just_pressed(input):
			any_valid = true;

	if(any_valid):
		var velocity = Input.get_vector(input_checks[0], input_checks[1], input_checks[2], input_checks[3])
		if velocity != Vector2.ZERO:
			get_offset(velocity)
			
func get_offset(direction):
	var cam_relative = (Global.camera.global_basis * Vector3(direction.x, 0, -direction.y)).normalized()
	if (abs(cam_relative.x) > abs(cam_relative.z)):
		return sign(cam_relative.x) * Vector3.RIGHT
	else:
		return sign(cam_relative.z) * Vector3.BACK
