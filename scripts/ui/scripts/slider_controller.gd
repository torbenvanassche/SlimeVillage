extends Node

@export var window: DraggableControl;
@export var slider: HSlider;
@export var max_count_label: Label;

func on_enable(dict: Dictionary = {}):
	var slot: ItemSlotUI = dict.slot;
	slider.min_value = 0;
	slider.max_value = slot.slot_data.item.count;
	slider.value = slot.slot_data.item.count / 2;
	max_count_label.text = str(slot.slot_data.item.count);
	pass
