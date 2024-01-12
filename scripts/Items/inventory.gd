class_name  Inventory
extends Node

var data: Array[Dictionary] = []
var max_slots: int

var ui: InventoryUI = null;

func init(inventory_ui: InventoryUI, slots: int = 4):
	ui = inventory_ui;
	max_slots = slots;

func add_item(item: Dictionary, make_slot_if_full: bool = true, amount: int = 1):
	var require_update: bool = false;		
	var remaining_amount: int = amount
	var slots: Array[Dictionary] = try_get_slots(item);
	var current_index: int = 0;
	
	while remaining_amount > 0:
		if slots.size() == 0 && (data.size() < max_slots || make_slot_if_full):
			slots.append(_create_slot(item))
			
		if slots.size() == 0:
			break;
		
		if _try_add(item, slots[0]):
			remaining_amount -= 1;
			require_update = true;
		else:
			slots.erase(slots[0])
	
	if require_update:
		try_update_ui()
		
	return remaining_amount;
	
func remove_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;		
	var remaining_amount: int = amount
	var slots: Array[Dictionary] = try_get_slots(item);
	var current_index: int = 0;
	
	while remaining_amount > 0:		
		if slots.size() == 0:
			break;
			
		slots[0].count -= 1;
		remaining_amount -= 1;
		if slots[0].count <= 0:
			slots.erase(slots[0])
	
	if require_update:
		try_update_ui()
		
	return remaining_amount;

func _create_slot(item: Dictionary):
	var entry = {"name": item.name, "count": 0, "stack_size": item.stack_size, "sprite": ItemManager.get_sprite(item)};
	data.append(entry);
	return entry;
		
func try_update_ui():
	if ui: 
		ui.update(data)
	return true;
				
func _try_add(item: Dictionary, slot: Dictionary) -> bool:
	if slot.name == item.name and slot.count < slot.stack_size:
		slot.count += 1
		return true
	return false
		
func add_item_by_id(item: String, amount: int = 1):
	add_item(ItemManager.get_item(item), amount)
	
func try_get_slots(item: Dictionary) -> Array[Dictionary]:
	var slots: Array[Dictionary] = []
	for i in range(data.size()):
		if data[i].name == item.name && data[i].count < data[i].stack_size:
			slots.append(data[i])
	return slots

func get_item_count(item_name: String = ""):
	var total_count = 0
	for i in data:
		if item_name == "" || item_name == i.name:
			total_count += i.count
	return total_count
