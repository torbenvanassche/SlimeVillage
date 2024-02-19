extends TextureRect

var is_dragging := false;

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new();
	
	preview_texture.texture = texture;
	preview_texture.expand_mode = 1
	preview_texture.size = size * 0.75;
	
	var preview = Control.new();
	preview.add_child(preview_texture);
	
	#change this to make it work regardless of where it is. possibly need the Item to store a reference to its item data
	var slot = (Global.player_instance.inventory as Inventory).data[get_parent().get_index()];
	get_parent().set_item({})
	slot.set_meta("previous", get_parent());
	set_drag_preview(preview);
	
	is_dragging = true;
	return slot
	
func _can_drop_data(at_position, data):
	return data is Dictionary && data.item != {} && !get_parent().disabled;
	
func _drop_data(at_position, data):
	(Global.player_instance.inventory as Inventory).swap_slots(data, get_parent().get_index(), data.get_meta("previous"));
	data.remove_meta("previous")
	is_dragging = false;
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful() && is_dragging:
				(Global.player_instance.inventory as Inventory).refresh_ui();
				is_dragging = false;
