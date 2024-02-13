class_name ItemProcessor
extends Control

@onready var item_slot: ItemSlot = $PuzzlePanel/MarginContainer/VBoxContainer/Item;
@onready var progress_bar: ProgressBar = $PuzzlePanel/MarginContainer/VBoxContainer/ProgressBar;
@onready var start_button: Button = $PuzzlePanel/MarginContainer/VBoxContainer/Start;
@onready var processing_timer: Timer = $PuzzlePanel/MarginContainer/VBoxContainer/Item/Timer;
@onready var window: Window = $"../";

@export var process_method: Helpers.CRAFT_METHOD;

var input_item: Dictionary;

func _ready():
	start_button.pressed.connect(_start_process)
	processing_timer.timeout.connect(_process_item)
	_deferred_ready.call_deferred()
	
func _deferred_ready():
	window.inventory.item_clicked.connect(set_item)
	
func _process(delta):
	if !processing_timer.is_stopped():
		progress_bar.value = 1 - (processing_timer.time_left / processing_timer.wait_time);

func _start_process():
	if !item_slot.item_name.is_empty():
		processing_timer.start();
		
func _process_item():
	ItemManager.get_craftables(input_item.id, Helpers.CRAFT_METHOD.GRIND)

func set_item(data: Dictionary):
	input_item = data.item;
	item_slot.set_item(data);
	var craftable = ItemManager.get_craftables([input_item.id], Helpers.CRAFT_METHOD.GRIND);
	processing_timer.wait_time = craftable.values()[0].processing_time;
