extends Window

@onready var inventory: InventoryUI = $"Inventory";

func _ready():
	close_requested.connect(hide)
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()

func on_enable():
	inventory.on_enable();
