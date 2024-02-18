extends TextureRect

var is_dragging := false;

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new();
	
	preview_texture.texture = texture;
	preview_texture.expand_mode = 1
	preview_texture.size = size * 0.75;
	
	var preview = Control.new();
	preview.add_child(preview_texture);
	
	var item_data = (Global.player_instance.inventory as Inventory).data[get_parent().get_index()];
	get_parent().set_item({})
	item_data.previous_index = get_parent().get_index();
	set_drag_preview(preview);
	
	is_dragging = true;
	
	return item_data
	
func _can_drop_data(at_position, data):
	return data is Dictionary && data.item != {} && !get_parent().disabled;
	
func _drop_data(at_position, data):
	(Global.player_instance.inventory as Inventory).swap_slots(data, get_parent().get_index(), data.previous_index);
	is_dragging = false;
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful() && is_dragging:
				(Global.player_instance.inventory as Inventory).refresh_ui();
