class_name ItemSlot
extends Button

var textureRect: Variant;
var counter: Variant;
var item_name: String = "";

@export var show_amount: bool = true:
	set(value):
		if counter:
			counter.visible = value;
		show_amount = value;

func _ready():
	textureRect = $ItemSprite;
	counter = $Count;
	
	counter.visible = show_amount;
	
func set_item(data: Dictionary):
	var sprite: Texture = null;
	
	if data.has("id"):
		item_name = data.id;
		sprite = ItemManager.get_sprite(data);
		if !data.has("count"):
			data.count = 1;
		counter.set_text(str(data.count));
	textureRect.set_texture(sprite);
