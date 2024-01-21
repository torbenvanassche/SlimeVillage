extends Window

@export var inventory_ui: InventoryUI;
@export var item_layout: Node;

func _ready():
	close_requested.connect(hide)

func enable(options: Dictionary):
	inventory_ui.set_controller(options.player.inventory);
	inventory_ui.item_clicked.connect(_set_to_cursor)
	show();
	
func _set_to_cursor(data: Dictionary):
	item_layout.open();
	pass
