class_name ItemSlotUI
extends Button

@export var textureRect: TextureRect;
@export var counter: Label;
var slot_data: ItemSlot;

@export var default_color = Color(Color.WHITE)
@export var dragging_color = Color(Color.WHITE, 0.3);

@export var show_amount: bool = true:
	set(value):
		counter.visible = value;
		show_amount = value;

func _ready():	
	counter.visible = show_amount;
	
func resize(x: int, y: int):
	textureRect
	
func as_blank():
	textureRect.modulate = dragging_color;
	counter.visible = false;
	
func redraw():
	var sprite = null;
	tooltip_text = "";
	textureRect.modulate = default_color
	counter.visible = false;
	
	if slot_data.item.has("id"):
		sprite = ItemManager.get_sprite(slot_data.item);
		if !slot_data.item.has("count"):
			slot_data.item.count = 1;
		counter.set_text(str(slot_data.item.count));
		counter.visible = show_amount && slot_data.item.count > 0;
		tooltip_text = slot_data.item.name;
	textureRect.set_texture(sprite);
	
func set_reference(data: ItemSlot):
	slot_data = data;
	slot_data.has_changed.connect(redraw)
	redraw()
