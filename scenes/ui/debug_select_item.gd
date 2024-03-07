extends Control

@onready var item_selector = $TextEdit;
@onready var confirm_button = $Button;

func _ready():
	for item in ItemManager._items:
		item_selector.add_item(item);
		
	_defer.call_deferred()

func _defer():
	confirm_button.pressed.connect(Global.player_instance.inventory.add_item_by_id.bind(item_selector.get_item_text(item_selector.selected)))
