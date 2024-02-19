class_name ItemSlot;
extends Node;

var item: Dictionary = {};
var is_available = false;

func _init(available: bool = true):
	is_available = available;

func has_space(id: String, amount: int = 1) -> bool:
	if !is_available:
		return false;
		
	if item == {}:
		return true;
		
	return item.stack_size - item.count - amount > 0;
	
func add(amount: int = 1, dict: Dictionary = item) -> int:
	if item == {}:
		item = dict.duplicate();
		item.count = 0;
	
	if dict.id == item.id:
		var remaining_space = item.stack_size - item.count
		var amount_to_add = min(amount, remaining_space)
		item.count += amount_to_add
		return amount - amount_to_add
	return amount;
