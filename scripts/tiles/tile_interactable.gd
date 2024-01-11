class_name TileInteractable
extends TileBase

@export var interaction: Node;

func initialize(data: Dictionary = {}):
	self.input_event.connect(execute)
	if data != {}:
		interaction.item_data = data;

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("mouse_left"):
		if !Global.player_instance.is_adjacent(self):
			Global.player_instance.try_move(self, true)
		else:
			if interaction && interaction.has_method("execute"):
				interaction.execute();
			else:
				print("interaction on " + self.name + " is not set.")
