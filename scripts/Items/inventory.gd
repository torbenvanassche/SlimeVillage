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
	var indices: Array[int] = try_get_indices(item);
	var current_index: int = 0;
	
	var current_slot: Dictionary;
	if (data.size() < max_slots || make_slot_if_full):
		if indices.size() == 0:
			current_slot = _create_slot(item)
			data.append(current_slot)
	indices = try_get_indices(item)
	
	while remaining_amount > 0:
		if _try_add(item, indices[current_index]):
			remaining_amount -= 1;
			require_update = true;
		else: current_index += 1;
	
	if require_update:
		try_update_ui()
		
	return remaining_amount;

func _create_slot(item: Dictionary):
	return {"name": item.name, "count": 0, "stack_size": item.stack_size, "sprite": ItemManager.get_sprite(item)};
		
func try_update_ui():
	if ui: 
		ui.update(data)
	return true;
				
func _try_add(item: Dictionary, slot: int) -> bool:
	if get_item_in_slot(slot).name == item.name and data[slot].count < data[slot].stack_size:
		data[slot].count += 1
		return true
	return false
		
func add_item_by_name(item: String, amount: int = 1):
	add_item(ItemManager.items[item], amount)	

func get_item_in_slot(slot: int) -> Dictionary:
	return data[slot]
	
func remove_item(item: Dictionary, count: int):
	var remove_count = count
	var indices = try_get_indices(item)
	while remove_count > 0:
		for index in indices:
			if data[index].count > 0:
				data[index].count -= count
				remove_count -= 1
				
				if data[index].count == 0:
					data.remove_at(index)
					
	try_update_ui()
	
func try_get_indices(item: Dictionary) -> Array[int]:
	var indices: Array[int] = []
	for i in range(data.size()):
		if data[i].name == item.name:
			indices.append(i)
	return indices

func get_item_count(item_name: String = ""):
	var total_count = 0
	for i in data:
		if item_name == "" || item_name == i.name:
			total_count += i.count
	return total_count
