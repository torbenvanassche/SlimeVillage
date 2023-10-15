extends TileTrigger

func _ready():
	super()
	
	items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)

func _entered():
	_open_mine()

func _open_mine():
	Global.scene_manager.active_scene = Global.scene_manager.get_scene("mine")
	var mine = Global.scene_manager.active_scene as itemized_hex_grid;
	mine.generate(Settings.mine_grid_size, items, 1, 0)
	pass
