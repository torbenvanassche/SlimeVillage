extends ItemSlotUI

signal on_drag_end(b: ItemSlotUI);
var puzzle_controller: FittingPuzzle;

func _get_drag_data(at_position):
	if slot_data.item != {}:
		as_blank();
		return self;
	return null;
	
func _can_drop_data(at_position, data):
	return data is ItemSlotUI && self is ItemSlotUI && slot_data.is_available;
	
func _drop_data(at_position, data):
	puzzle_controller.add_item(self, data.slot_data.item);
	data.slot_data.remove();
	on_drag_end.emit(self);
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
