class_name DragController
extends Node

static var start_item: Dictionary;
static var start_slot: ItemSlotUI;
static var start_window: String;

static func DRAG_START(_start_slot: ItemSlotUI, origin_window: String):
	start_item = _start_slot.slot_data.item.duplicate();
	start_slot = _start_slot;
	start_window = origin_window;
	
	match origin_window:
		"Inventory":
			_start_slot.as_blank()
		"Puzzle":
			Global.ui_root.mechanic_window.grid_puzzle.reset_tiles(start_slot)

static func DRAG_END(end_slot: ItemSlotUI, destination_window: String):
	match destination_window:
		"Inventory":
			if (end_slot.slot_data.item != {} && start_item.id == end_slot.slot_data.item.id) || end_slot.slot_data.item == {}:
				var remainder = end_slot.slot_data.add(start_item, start_item.count);
				start_slot.slot_data.remove(start_item.count - remainder)
			elif start_item.id != end_slot.slot_data.item.id && start_window == "Inventory":
				var end_item = end_slot.slot_data.item;
				end_slot.slot_data.item = start_item;
				start_slot.slot_data.item = end_item;
		"Puzzle":
			Global.ui_root.mechanic_window.grid_puzzle.add_item(end_slot, start_item)
			start_slot.slot_data.remove(1)
		"Grinder":
			if Global.ui_root.mechanic_window.grinder.set_item(start_item, true):
				start_slot.slot_data.remove(1);
			else: start_slot.redraw()
			
	start_item = {};
	start_slot = null;
