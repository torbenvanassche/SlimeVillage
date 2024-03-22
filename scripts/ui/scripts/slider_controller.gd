extends Node

@export var window: DraggableControl;
@export var slider: HSlider;
@export var max_count_label: Label;
@export var confirm_button = Button;

var slot: ItemSlotUI;

func _ready():
	confirm_button.pressed.connect(_split_slot)
	confirm_button.pressed.connect(_on_close)

func on_enable(dict: Dictionary = {}):
	slot = dict.slot;
	slider.min_value = 0;
	slider.max_value = slot.slot_data.item.count;
	slider.value = slot.slot_data.item.count / 2;
	max_count_label.text = str(slot.slot_data.item.count);
	
func _split_slot():
	Global.player_instance.inventory.add_item(slot.slot_data.item, slider.value, false, true)
	slot.slot_data.remove(slider.value);	

func _on_close():
	window.hide();
