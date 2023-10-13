extends ItemSpawner

func _ready():
	super()
	
	items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)

func _entered():
	var mouse_position = get_viewport().get_mouse_position()
	Global.event_context_menu_open.emit(ContextMenu.format_options("Open mine", 0, Callable(_open_mine)), Rect2i(mouse_position.x, mouse_position.y, 0, 0))

func _open_mine():
	Global.scene_manager.active_scene = Global.scene_manager.get_scene("mine")
	var mine = Global.scene_manager.active_scene as mine_hex_generator;
	mine.generate(Settings.hex_grid_size, items, 1, 0)
	
	Global.player_instance.set_position_to_current_tile(mine.get_tile(ceil(Settings.hex_grid_size.x / 2.0)))
	pass
