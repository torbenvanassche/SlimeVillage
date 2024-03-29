extends Node3D

@export var interaction: Interaction;
@export var require_adjacent: bool = false;
@export var static_body: StaticBody3D = null;
@onready var fallback: StaticBody3D = get_node_or_null("StaticBody3D");

func _ready():
	if !static_body:
		static_body = fallback;
		if !static_body:
			printerr("No static body assigned on " + self.name)
			return;
	static_body.input_event.connect(execute)

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if !require_adjacent || Global.player_instance.is_near(self, 1.5):
		if _event.is_action_pressed("mouse_left") && interaction:
			interaction.execute();
