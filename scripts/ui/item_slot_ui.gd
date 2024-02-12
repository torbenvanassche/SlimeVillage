class_name ItemSlot
extends Button

var textureRect: Variant;
var counter: Variant;
var item_name: String = "";

@export var show_amount: bool = true;

func _ready():
	textureRect = $ItemSprite;
	counter = $Count;
	
	counter.visible = show_amount;
	
func set_item(data: Dictionary):
	item_name = data.item.id;
	counter.set_text(str(data.item.count));
	textureRect.set_texture(data.item.sprite);
