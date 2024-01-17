class_name ItemSlot
extends Button

var textureRect: Variant;
var counter: Variant;

var item_name: String = "";

func _ready():
	textureRect = $ItemSprite;
	counter = $Count;
	
func set_item(data: Dictionary):
	item_name = data.item.name;
	counter.set_text(str(data.item.count));
	textureRect.set_texture(data.item.sprite);
