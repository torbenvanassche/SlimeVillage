class_name ItemSlotUI
extends Button

@export var textureRect: TextureRect;
@export var counter: Label;
var slot_data: ItemSlot;

@export var show_amount: bool = true:
	set(value):
		counter.visible = value;
		show_amount = value;

func _ready():	
	counter.visible = show_amount;
	
func as_blank():
	textureRect.texture = null;
	counter.visible = false;
	
func redraw():
	var sprite = null;
	counter.visible = false;
	
	if slot_data.item.has("id"):
		sprite = ItemManager.get_sprite(slot_data.item);
		if !slot_data.item.has("count"):
			slot_data.item.count = 1;
		counter.set_text(str(slot_data.item.count));
		counter.visible = show_amount && slot_data.item.count > 0;
	textureRect.set_texture(sprite);
	
func set_reference(data: ItemSlot):
	slot_data = data;
	slot_data.has_changed.connect(redraw)
	redraw()
