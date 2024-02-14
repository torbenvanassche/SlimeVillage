extends Window

@onready var movement_dropdown: OptionButton = $VBoxContainer/movement_mode/move_mode;
@onready var volume_main: HSlider = $VBoxContainer/volume_main/volume_slider;
@onready var movement_speed: SpinBox = $VBoxContainer/movement_speed/SpinBox;

func _ready():
	#movement option toggles
	for option in Global.NAV_STYLE:
		movement_dropdown.add_item(option);
	movement_dropdown.selected = Settings.input_mode;
	movement_dropdown.item_selected.connect(Settings.set_input_mode)
	
	#Close menu
	close_requested.connect(_on_close)
	
	#Audio
	volume_main.value_changed.connect(func(value): Settings.volume_changed.emit(value, "Master"))
	
	_ready_deferred.call_deferred();

func _unhandled_input(event):	
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		close_requested.emit()
		
func _on_close():
	Global.ui_root.disable_ui(self)
	
func _ready_deferred():
	movement_speed.value = Global.player_instance.move_delay;
	movement_speed.value_changed.connect(Global.player_instance.set_speed);
