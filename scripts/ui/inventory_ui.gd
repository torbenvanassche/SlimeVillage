class_name InventoryUI
extends Window

var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");              
var elements: Array[ItemViewer] = []

var selected_item: Dictionary;

@onready var root: Node = $HFlowContainer;

func _ready():
	close_requested.connect(hide)

func add(item: Dictionary):
	var item_ui = item_ui_packed.instantiate() as ItemViewer;
	item_ui.pressed.connect(_set_selected.bind(item));
	root.add_child(item_ui);
	elements.append(item_ui);
	item_ui.set_item(item);
	
func _set_selected(item: Dictionary):
	selected_item = item;
	
func reset_selection():
	selected_item.clear();

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func update(data: Array[Dictionary]):
	_clear();
	for index in range(data.size()):
		add(data[index])
