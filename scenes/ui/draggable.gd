extends TextureRect

var is_dragging := false;

func _get_drag_data(at_position):
	if get_parent().slot_data.item == {}:
		return null;
	
	var preview_texture = TextureRect.new();
	
	preview_texture.texture = texture;
	preview_texture.expand_mode = 1
	preview_texture.size = size * 0.75;
	
	var preview = Control.new();
	preview.z_index = RenderingServer.CANVAS_ITEM_Z_MAX;
	preview.add_child(preview_texture);
	
	var slotUI = get_parent();
	#DragController.on_drag_start.emit();
	set_drag_preview(preview);
	
	is_dragging = true;
	return slotUI
	
func _can_drop_data(at_position, data):
	return data is ItemSlotUI && data.slot_data.item != {} && !get_parent().disabled;
	
func _drop_data(at_position, data):
	#DragController.on_drag_end.emit()
	is_dragging = false;
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful() && is_dragging:
				(Global.player_instance.inventory as Inventory).refresh_ui();
				is_dragging = false;
