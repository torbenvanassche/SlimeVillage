class_name ContextMenu
extends PopupMenu

var menu_items: Array[ContextMenuItem];

func _init(data: Array[ContextMenuItem]):
	for index in range(data.size()):
		var context_item := data[index];
		add_item(context_item.id, index)
		context_item.idx = index;
	index_pressed.connect(_on_idx)
	menu_items = data
	
func _on_idx(index):
	menu_items.find(func(x: ContextMenuItem): return x.idx == index);
