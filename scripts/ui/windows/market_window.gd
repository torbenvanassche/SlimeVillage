extends Window

@onready var note_item: PackedScene = preload("res://scenes/ui/market_note_item.tscn")
@onready var note_container: VBoxContainer = $note;

var notes: Array[NoteItem]

# Called when the node enters the scene tree for the first time.
func _ready():
	close_requested.connect(hide);

func _unhandled_input(event):	
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		close_requested.emit()

func on_enable(dict: Dictionary):
	for c in note_container.get_children():
		c.queue_free();
	
	if dict.has("inventory"):
		for slot in dict.inventory.data:
			if slot.item != {}:
				var instance = note_item.instantiate() as NoteItem;
				instance.set_item(slot.item.name, slot.item.count, slot.item.sprite)
				note_container.add_child(instance)
