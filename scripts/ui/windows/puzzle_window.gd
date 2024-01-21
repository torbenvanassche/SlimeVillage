extends Window

@export var inventory_ui: InventoryUI;

func _ready():
	close_requested.connect(hide)

func enable(options: Dictionary):
	inventory_ui.set_controller(options.player.inventory);
	show();
