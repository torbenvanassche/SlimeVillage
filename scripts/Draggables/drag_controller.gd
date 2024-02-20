class_name DragController
extends Node

static var start_item: Dictionary;
static var start_slot: ItemSlotUI;

static func DRAG_START(_start_slot: ItemSlotUI, origin_window: String):
	start_item = _start_slot.slot_data.item.duplicate();
	start_slot = _start_slot;
	
	match origin_window:
		"Inventory":
			_start_slot.as_blank()
		"Puzzle":
			Global.ui_root.mechanic_window.grid_puzzle.reset_tiles(start_slot)

static func DRAG_END(end_slot: ItemSlotUI, destination_window: String):
	match destination_window:
		"Inventory":
			end_slot.slot_data.add(start_item, start_item.count);
			start_slot.slot_data.remove(start_item.count)
		"Puzzle":
			Global.ui_root.mechanic_window.grid_puzzle.add_item(end_slot, start_item)
			start_slot.slot_data.remove(1)
		"Grinder":
			if Global.ui_root.mechanic_window.grinder.set_item(start_item, true):
				start_slot.slot_data.remove(1);
			else: start_slot.redraw()
			
	start_item = {};
	start_slot = null;
