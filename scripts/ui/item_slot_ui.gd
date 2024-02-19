class_name ItemSlotUI
extends Button

var textureRect: Variant;
var counter: Variant;
var item_data: Dictionary = {};

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
	counter.visible = false;
	
	if data.has("id"):
		item_data = data;
		sprite = ItemManager.get_sprite(data);
		if !data.has("count"):
			data.count = 1;
		counter.set_text(str(data.count));
		counter.visible = true;
	textureRect.set_texture(sprite);
