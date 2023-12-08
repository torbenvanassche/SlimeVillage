class_name Interactable
extends Node

@export var interaction: Node;

func initialize(data: Dictionary):
	$StaticBody3D.input_event.connect(execute)
	interaction.item_data = data;

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("mouse_left"):
		if !Global.player_instance.is_adjacent(self.get_parent()):
			Global.player_instance.try_move(self.get_parent(), true)
		else:
			if interaction && interaction.has_method("execute"):
				interaction.execute();

