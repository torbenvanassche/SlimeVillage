extends ItemSlotUI

signal on_drag_end(b: ItemSlotUI);

func _get_drag_data(at_position):
	if slot_data.item != {}:
		as_blank();
		return self;
	return null;
	
func _can_drop_data(at_position, data):
	return data is ItemSlotUI && self is ItemSlotUI && slot_data.is_available;
	
func _drop_data(at_position, data):
	var current_reference = slot_data;
	set_reference(data.slot_data);
	data.set_reference(current_reference);
	on_drag_end.emit(self)
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
