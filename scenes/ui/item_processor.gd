class_name ItemProcessor
extends Control

@onready var item_slot: ItemSlot = $PuzzlePanel/MarginContainer/VBoxContainer/Item;
@onready var progress_bar: ProgressBar = $PuzzlePanel/MarginContainer/VBoxContainer/ProgressBar;
@onready var start_button: Button = $PuzzlePanel/MarginContainer/VBoxContainer/Start;
@onready var processing_timer: Timer = $PuzzlePanel/MarginContainer/VBoxContainer/Item/Timer;
@onready var window: Window = $"../";

@export var process_method: Helpers.CRAFT_METHOD;

var input_item: Dictionary;
var possible_output: Dictionary;
var output_options: Array;

func _ready():
	start_button.pressed.connect(_start_process)
	processing_timer.timeout.connect(_process_item)
	_deferred_ready.call_deferred()
	
func _deferred_ready():
	#window.inventory.item_clicked.connect(_set_item)
	window.close_requested.connect(on_close)
	
func _process(delta):
	if !processing_timer.is_stopped():
		progress_bar.value = 1 - (processing_timer.time_left / processing_timer.wait_time);

func _start_process():
	if !item_slot.item_name.is_empty():
		processing_timer.start();
		
func _process_item():
	window.inventory.controller.remove_item(input_item)
	window.inventory.controller.add_item(possible_output)
	item_slot.set_item({});
	input_item = {};

func _set_item(data: Dictionary, prepare_craft: bool = true):
	if data != {} && data.has("id"):
		output_options = ItemManager.get_craftables([data.id], Helpers.CRAFT_METHOD.GRIND).values();
		if output_options.size() == 0:
			return
		possible_output = output_options[0];
		if prepare_craft:
			processing_timer.wait_time = possible_output.processing_time;	
		input_item = data;
		item_slot.set_item(data);
		
func on_close():
		input_item = {};
		item_slot.set_item({});
		processing_timer.stop();
		visible = false;
