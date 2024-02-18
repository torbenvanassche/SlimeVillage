class_name  Inventory
extends Node

var data: Array[Dictionary] = []
@export var unlocked_slots: int
@export var max_slots: int;

signal inventory_changed(data: Array[Dictionary]);

func _ready():	
	for i in range(max_slots):
		var slot = _create_slot_data(i < unlocked_slots);
		data.append(slot)
		
func _create_slot_data(available: bool):
	var slot = {};
	slot.is_available = available;
	slot.item = {};
	return slot;
	
func add_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;
	var remaining_amount: int = amount
	var slots: Array[Dictionary] = try_get_slots(item);
	
	while remaining_amount > 0:
		if slots.size() == 0:
			break;
		
		if slots.size() != 0 && _try_add(item, slots[0]):
			remaining_amount -= 1;
			require_update = true;
		else:
			slots.erase(slots[0])
			
	if require_update:
		inventory_changed.emit(data)
		
	return remaining_amount;
	
func refresh_ui():
	inventory_changed.emit(data)
	
func remove_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;		
	var remaining_amount: int = amount
	var slots: Array[Dictionary] = try_get_slots(item);
	slots = slots.filter(func(x): return x.item != {})
	
	while remaining_amount > 0:		
		if slots.size() == 0:
			break;
			
		slots[0].item.count -= 1;
		remaining_amount -= 1;
		require_update = true;
		if slots[0].item.count <= 0:
			data[slots[0].slot_index].item = {}
			slots.erase(slots[0])
			
	if require_update:
		inventory_changed.emit(data)
		
	return remaining_amount;
				
func _try_add(item: Dictionary, slot: Dictionary) -> bool:	
	if slot.item == {}:
		slot.item = {"name": item.name, "count": 1, "id": item.id, "stack_size": item.stack_size, "sprite": ItemManager.get_sprite(item), "layout": ItemManager.get_layout(item)};
		return true;
	
	if (slot.item.name == item.name and slot.item.count < slot.item.stack_size):
		slot.item.count += 1
		return true
	return false
		
func add_item_by_id(item: String, amount: int = 1):
	add_item(ItemManager.get_item(item), amount)
	
func try_get_slots(dict: Dictionary) -> Array[Dictionary]:
	var slots: Array[Dictionary] = []
	for i in range(data.size()):
		if data[i].is_available:
			if data[i].item == {}:
				data[i].slot_index = i;
				slots.append(data[i]);
				continue;		
			if data[i].item.id == dict.id &&  data[i].item.count < data[i].item.stack_size:
				data[i].slot_index = i;
				slots.append(data[i])
	return slots

func get_item_count(item_name: String = ""):
	var total_count = 0
	for i in data:
		if item_name == "" || item_name == i.item.name:
			total_count += i.item.count
	return total_count

func swap_slots(item: Dictionary, index: int, previous_index: int):
	var old_value = data[index];
	data[index] = item;
	data[previous_index] = old_value;
	inventory_changed.emit(data)
	item.erase("previous_index")
