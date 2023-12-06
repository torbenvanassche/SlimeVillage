class_name Interactable
extends Node

func initialize(data: Dictionary):
	$StaticBody3D.input_event.connect(_on_click)

func _on_click(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left"):
		if !_on_interact_internal():
			Global.player_instance.navigator.try_move(self.get_parent(), _on_interact_internal, true)
	
func _on_interact_internal():
	if Global.player_instance.navigator.is_adjacent(self.get_parent()):
		return true;
		
	return false;
