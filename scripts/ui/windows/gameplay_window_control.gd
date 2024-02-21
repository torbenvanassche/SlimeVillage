extends Window

@onready var inventory: InventoryUI = $Inventory;
@onready var grid_puzzle: FittingPuzzle = $GridPuzzle;
@onready var grinder: ItemProcessor = $Grinder;

var enabled_control: Control;

func _ready():
	close_requested.connect(hide)
	
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		close_requested.emit()

func on_enable(options: Dictionary):
	title = options.title;
	inventory.on_enable();
	
	if options.id == "puzzle":
		_enable(grid_puzzle)
	elif options.id == "grinder":
		_enable(grinder)

func _enable(c: Control):
	if enabled_control && enabled_control.has_method("on_close"):
		enabled_control.on_close();
	
	c.visible = true;
	enabled_control = c;
	if c.has_method("on_enable"):
		c.on_enable();