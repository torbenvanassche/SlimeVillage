extends Window

@onready var item_slot: ItemSlot = $"VBoxContainer/Item";
@onready var progress_bar: ProgressBar = $"VBoxContainer/ProgressBar";
@onready var start_button: Button = $"VBoxContainer/Start"

@onready var processing_timer: Timer = $"VBoxContainer/Item/Timer";
@export var process_method: String;

var input_item: Dictionary;

func _ready():
	close_requested.connect(_on_close)
	start_button.pressed.connect(_start_process)
	processing_timer.timeout.connect(_process_item)
	
	_process_item()
	
func _process(delta):
	if !processing_timer.is_stopped():
		progress_bar.value = 1 - (processing_timer.time_left / processing_timer.wait_time);

func _start_process():
	if !item_slot.item_name.is_empty():
		processing_timer.start();
		
func _process_item():
	ItemManager.get_craftables(["wheat"], Helpers.CRAFT_METHOD.GRIND)

func _on_close():
	Global.ui_root.disable_ui(self)

func set_item(data: Dictionary):
	if data.has("process") && data.process == process_method:
		processing_timer.wait_time = data.processing_time;
		item_slot.set_item(data);
