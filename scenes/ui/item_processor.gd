class_name ItemProcessor
extends Control

@onready var item_slot_ui: ItemSlotUI = $PuzzlePanel/MarginContainer/VBoxContainer/Item;
@onready var progress_bar: ProgressBar = $PuzzlePanel/MarginContainer/VBoxContainer/ProgressBar;
@onready var start_button: Button = $PuzzlePanel/MarginContainer/VBoxContainer/Start;
@onready var processing_timer: Timer = $PuzzlePanel/MarginContainer/VBoxContainer/Item/Timer;
@onready var window: Window = $"../";

@export var process_method: Helpers.CRAFT_METHOD;

var possible_output: Dictionary;
var output_options: Array;

func _ready():
	start_button.pressed.connect(_start_process)
	processing_timer.timeout.connect(_process_item)
	_deferred_ready.call_deferred()
	
	item_slot_ui.set_reference(ItemSlot.new(true, "Grinder"))
	
func _deferred_ready():
	window.close_requested.connect(on_close)
	
func _process(delta):
	if !processing_timer.is_stopped():
		progress_bar.value = 1 - (processing_timer.time_left / processing_timer.wait_time);

func _start_process():
	if item_slot_ui.slot_data.item != {}:
		processing_timer.start();
		
func _process_item():
	item_slot_ui.slot_data.reset()
	item_slot_ui.slot_data.add(possible_output);

func set_item(data: Dictionary, prepare_craft: bool = true):
	if data != {} && data.has("id"):
		output_options = ItemManager.get_craftables([data.id], Helpers.CRAFT_METHOD.GRIND).values();
		if output_options.size() == 0:
			return false
		possible_output = output_options[0];
		if prepare_craft:
			processing_timer.wait_time = possible_output.processing_time;	
		item_slot_ui.slot_data.add(data);
	return true;
		
func on_close():
		item_slot_ui.slot_data.reset();
		processing_timer.stop();
		visible = false;
