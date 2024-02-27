extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	close_requested.connect(hide);

func _unhandled_input(event):	
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		close_requested.emit()
