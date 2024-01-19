extends Window

@onready var inventory_ui: InventoryUI = $Grid;

func _ready():
	close_requested.connect(hide)

func enable(pos: Vector2):
	#Doing get_viewport() seems to target self instead of the main window
	position = pos.clamp(Vector2(10, 35), get_tree().root.get_viewport().size - size);
	show();
		
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()
