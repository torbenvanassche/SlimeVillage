extends Window

@export var inventory_ui: InventoryUI;
@export var item_layout: Shaper;

func _ready():
	close_requested.connect(hide)
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()

func on_enable():
	inventory_ui.set_controller(Global.player_instance.inventory);
	inventory_ui.item_clicked.connect(_set_to_cursor)
	show();
	
func _set_to_cursor(_data: Dictionary):
	item_layout.open([true], 2)
	pass
