extends Node

func execute():
	Global.manager.set_active_scene(Global.manager.get_scene_by_name("area_mine"))
	
	var mine = Global.manager.active_scene as Grid;
	var items = ItemManager.get_by_property("location", "mine", ItemManager.get_by_property("available", true))
	mine.generate(items, Settings.mine_amount_to_spawn, Settings.mine_chance_to_fail)
	Global.player_instance.current_tile = mine.entrance;
	Global.player_instance.set_position_to_current_tile();
