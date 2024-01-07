class_name ItemViewer
extends Button

var textureRect: Variant;
var counter: Variant;

var item_name: String = "";
var item_count: int = 0;

func _ready():
	textureRect = $ItemSprite;
	counter = $Count;
	
func set_item(item: Dictionary):
	item_name = item.name;
	item_count = item.count;
	counter.set_text(str(item_count));
	textureRect.set_texture(item.sprite);
	counter.free()
