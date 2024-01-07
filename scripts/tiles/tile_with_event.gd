extends TileBase

@export var trigger: Triggerable;

func _execute_internal(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left") and walkable_in_scene and self != Global.player_instance.current_tile && Settings.input_mode == Global.NAV_STYLE.CLICK:
		Global.player_instance.try_move(self)
