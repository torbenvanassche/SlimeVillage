extends Node

func execute():
	Global.scene_manager.set_active_scene(Global.scene_manager.get_scene_by_name("mine_subarea"))
	
	var mine = Global.scene_manager.active_scene as Grid;
	var items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)
	mine.generate(Settings.mine_grid_size, items, Settings.mine_amount_to_spawn, Settings.mine_chance_to_fail, true)
	Global.player_instance.navigator.current_tile = mine.get_outer_ring().pick_random();
	Global.player_instance.navigator.set_position_to_current_tile();
