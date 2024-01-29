extends Node

@onready var movement_dropdown: OptionButton = $VBoxContainer/move_mode;

func _ready():
	for option in Global.NAV_STYLE:
		movement_dropdown.add_item(option);
	movement_dropdown.selected = Settings.input_mode;
	movement_dropdown.item_selected.connect(Settings.set_input_mode)
