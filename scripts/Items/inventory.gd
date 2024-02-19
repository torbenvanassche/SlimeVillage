class_name  Inventory
extends Node

var data: Array[ItemSlot] = []
@export var unlocked_slots: int
@export var max_slots: int;

signal inventory_changed(data: Array[ItemSlot]);

func _ready():	
	for i in range(max_slots):
		data.append(ItemSlot.new(i < unlocked_slots))
	
func add_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;
	var remaining_amount: int = amount
	var slots: Array[ItemSlot] = try_get_slots(item);
	
	while remaining_amount > 0:
		if slots.size() == 0:
			break;
		
		item = {"name": item.name, "id": item.id, "stack_size": item.stack_size, "sprite": ItemManager.get_sprite(item), "layout": ItemManager.get_layout(item)};
		remaining_amount = slots[0].add(remaining_amount, item);
		require_update = true;
			
	if require_update:
		inventory_changed.emit(data)
		
	return remaining_amount;
	
func refresh_ui():
	inventory_changed.emit(data)
	
func remove_item(item: Dictionary, amount: int = 1):
	var require_update: bool = false;		
	var remaining_amount: int = amount
	var slots: Array[ItemSlot] = try_get_slots(item);
	
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
		
func add_item_by_id(item: String, amount: int = 1):
	add_item(ItemManager.get_item(item), amount)
	
func try_get_slots(dict: Dictionary) -> Array[ItemSlot]:
	var slots: Array[ItemSlot] = []
	for i in range(data.size()):
		if data[i].has_space(dict.id):
			slots.append(data[i]);
	return slots

func get_item_count(item_name: String = ""):
	var total_count = 0
	for i in data:
		if item_name == "" || item_name == i.item.name:
			total_count += i.item.count
	return total_count
