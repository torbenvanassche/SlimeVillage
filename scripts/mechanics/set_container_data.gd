extends Button

@export var grid_preset_data: grid_preset;
@export var window: DraggableControl;

func _ready():
	pressed.connect(_on_pressed)
	
func _on_pressed():
	Global.player_instance.carryable_preset = grid_preset_data;
	window.close_requested.emit();
