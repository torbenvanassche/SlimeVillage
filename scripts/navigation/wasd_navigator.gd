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
			move(velocity)
			
func move(direction):
	var forward = Global.camera.global_transform.basis.z.normalized();
	forward.z = 0
	forward *= direction.y;
	var right = Global.camera.global_transform.basis.x * direction.x;
	var cam_relative = -forward - right;
	$MeshInstance3D.position = cam_relative;
	pass
