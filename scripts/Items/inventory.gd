class_name  Inventory
extends Node

var data: Array[Dictionary] = []
var max_slots: int

func _init(slots: int = 4):
	max_slots = slots

func add_item(item: Dictionary, make_slot_if_full: bool = true, amount: int = 1):
	var remaining_amount = amount
	var indices = try_get_indices(item)
	
	if(indices.size() == 0):
		data.append({"name": item["name"], "count": 1, "stack_size": item["stack_size"], "sprite_path": item["sprite_path"]})
		remaining_amount -= 1;
		add_item(item, make_slot_if_full, remaining_amount)
		Global.manager.player_inventory_ui.update(data)
		return
	
	while remaining_amount > 0:
		for slot in indices:
			if _try_add(item, slot):
				remaining_amount -= 1
				break;
		if remaining_amount == 0:
			Global.manager.player_inventory_ui.update(data)
			return
				
		if make_slot_if_full:
			add_item(item, make_slot_if_full, remaining_amount)
			Global.manager.player_inventory_ui.update(data)
			return;
		else:
			print("No slot created, controlled by parameter of add_item.")
				
func _try_add(item: Dictionary, slot: int) -> bool:
	if get_item_in_slot(slot)["name"] == item["name"] and data[slot]["count"] < data[slot]["stack_size"]:
		data[slot]["count"] += 1
		return true
	return false
		
func add_item_by_name(item: String, amount: int = 1):
	add_item(ItemManager.items[item], amount)
	
func get_free_slot(item: Dictionary, amount: int) -> int:
	for index in range(data.size()):
		if data[index] == item && data[index].count + amount < data[index]["stack_size"]:
			return index
	
	for index in range(data.size()):
		if not data[index]:
			return index
	return -1
	

func get_item_in_slot(slot: int) -> Dictionary:
	return data[slot]
	
func _get_empty_slot():
	for slot_index in range(data.size()):
		if !data[slot_index]:
			return slot_index
		else: 
			return null
	
func remove_item(item: Dictionary, count: int):
	var remove_count = count
	var indices = try_get_indices(item)
	while remove_count > 0:
		for index in indices:
			if data[index]["count"] > 0:
				data[index]["count"] -= count
				remove_count -= 1
				
				if data[index]["count"] == 0:
					data.remove_at(index)
	pass
	
func try_get_indices(item: Dictionary) -> Array[int]:
	var indices: Array[int] = []
	for i in range(data.size()):
		if data[i]["name"] == item["name"]:
			indices.append(i)
	return indices

func get_item_count():
	var total_count = 0
	for i in data:
		total_count += i["count"]
	return total_count
