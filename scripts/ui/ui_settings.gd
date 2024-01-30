extends Window

@onready var movement_dropdown: OptionButton = $VBoxContainer/HFlowContainer/move_mode;

func _ready():
	for option in Global.NAV_STYLE:
		movement_dropdown.add_item(option);
	movement_dropdown.selected = Settings.input_mode;
	movement_dropdown.item_selected.connect(Settings.set_input_mode)
	
	close_requested.connect(_on_close)
	
func _on_close():
	Global.ui_root.disable_ui(self)
