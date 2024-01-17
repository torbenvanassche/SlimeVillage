class_name InventoryUI
extends Window #type changed from Window to Popup ( https://github.com/godotengine/godot/issues/87291 )

var item_ui_packed: PackedScene = preload("res://scenes/ui/item_display_2d.tscn");              
var elements: Array[ItemSlot] = []

var selected_item: Dictionary;

@onready var root: Node = $Grid;

func _ready():
	close_requested.connect(hide)

func add(dict: Dictionary):
	var item_ui = item_ui_packed.instantiate() as ItemSlot;
	root.add_child(item_ui);
	elements.append(item_ui);
	
	if dict.has("is_available"):
		item_ui.visible = dict.is_available;
	
	if dict.has("item"):
		item_ui.pressed.connect(_set_selected.bind(dict));
		item_ui.set_item(dict);
	
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
		
func enable(pos: Vector2):
	#Doing get_viewport() seems to target self instead of the main window
	position = pos.clamp(Vector2(10, 35), get_tree().root.get_viewport().size - size);
	show();
		
func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		hide()
