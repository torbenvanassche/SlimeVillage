extends Window

@onready var inventory_ui: InventoryUI = $Grid;

func _ready():
	close_requested.connect(hide)
	_defer_ready.call_deferred();
	
func _defer_ready():
	inventory_ui.set_controller(Global.player_instance.inventory);

func enable(pos: Vector2 = get_tree().root.get_viewport().get_mouse_position()):
	#Doing get_viewport() seems to target self instead of the main window
	position = pos.clamp(Vector2(10, 35), get_tree().root.get_viewport().size - size);
	inventory_ui.on_enable();
	show();
		
func _unhandled_input(event):	
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		inventory_ui.reset_selection();
		close_requested.emit()
