extends Node

func execute():
	Global.manager.set_active_scene(Global.manager.get_scene_by_name("area_mine"))
	
	var mine = Global.manager.active_scene as Grid;
	var items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "mine").filter(func(x): return x["available"] == true)
	mine.generate(items, Settings.mine_amount_to_spawn, Settings.mine_chance_to_fail)
	Global.player_instance.current_tile = mine.entrance;
	Global.player_instance.set_position_to_current_tile();
