extends Window

@onready var inventory: InventoryUI = $Inventory;
@onready var grid_puzzle: FittingPuzzle = $GridPuzzle;
@onready var grinder: ItemProcessor = $Grinder;

func _ready():
	close_requested.connect(hide)
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()

func on_enable(options: Dictionary):
	title = options.title;
	inventory.on_enable();
