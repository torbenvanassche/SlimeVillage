extends Node

#Resources that this thing can generate
var location_resource_keys = []

func _init_resources():
	location_resource_keys = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)
	
func _ready():
	_init_resources()

func entered():
	var mouse_position = get_viewport().get_mouse_position()
	Global.event_context_menu_open.emit(ContextMenu.format_options("Open mine", 0, Callable(_open_mine)), Rect2i(mouse_position.x, mouse_position.y, 0, 0))

func _open_mine():
	Global.scene_manager.active_scene = Global.scene_manager.get_scene("mine")
	var mine = Global.scene_manager.active_scene as hex_grid;
	mine.generate(Settings.hex_grid_size)
	
	Global.player_instance.set_to_current_tile(mine.get_tile(ceil(Settings.hex_grid_size.x / 2.0)))
	pass
