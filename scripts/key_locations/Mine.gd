extends TileTrigger

func _ready():
	super()
	
	items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)

func _entered():
	_open_mine()

func _open_mine():
	Global.scene_manager.set_active_scene(Global.scene_manager.get_scene_by_name("mine_subarea"))
	var mine = Global.scene_manager.active_scene as Grid;
	mine.generate(Settings.mine_grid_size, items, Settings.mine_amount_to_spawn, Settings.mine_chance_to_fail)
	pass
