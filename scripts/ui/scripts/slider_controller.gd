extends Node

@export var window: DraggableControl;
@export var slider: HSlider;
@export var max_count_label: Label;

func on_enable(dict: Dictionary = {}):
	var slot: ItemSlotUI = dict.slot;
	slider.max_value = slot.count;
	slider.value = slot.count / 2;
	pass
