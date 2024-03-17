class_name ContextMenu
extends PopupMenu

signal on_split_stack();

func get_for_inventory():
	add_item("Split stack", 0);
	index_pressed.connect(_on_idx);
	return self;
	
func _on_idx(index):
	on_split_stack.emit();
