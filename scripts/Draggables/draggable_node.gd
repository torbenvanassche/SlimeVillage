extends TextureRect

static var is_dragging := false;

func _get_drag_data(_at_position):
	if get_parent().slot_data.item == {}:
		return

	var preview_texture = TextureRect.new();
	preview_texture.texture = texture;
	preview_texture.expand_mode = 1
	preview_texture.size = size * 0.75;
	var preview = Control.new();
	preview.z_index = RenderingServer.CANVAS_ITEM_Z_MAX;
	preview.add_child(preview_texture);
	set_drag_preview(preview);
	
	var result := get_parent();
	DragController.DRAG_START(result, result.slot_data.window_id)
	
	is_dragging = true;
	return result	
	
func _can_drop_data(_at_position, _data):
	return !get_parent().disabled;
	
func _drop_data(_at_position, _data):
	var result = get_parent();
	DragController.DRAG_END(result, result.slot_data.window_id)
	is_dragging = false;
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful() && is_dragging:
				(Global.player_instance.inventory as Inventory).refresh_ui();
				is_dragging = false;
