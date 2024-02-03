extends Node3D

@export var interaction: Node;
@export var require_adjacent: bool = false;

func _ready():
	if !interaction:
		interaction = $StaticBody3D;
	
	$StaticBody3D.input_event.connect(execute)

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if !require_adjacent || Global.player_instance.is_near(self, 1.5):
		if _event.is_action_pressed("mouse_left") && interaction && interaction.has_method("execute"):
			interaction.execute({"player": Global.player_instance});
