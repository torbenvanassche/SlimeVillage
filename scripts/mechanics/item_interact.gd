extends Node

var item_data: Dictionary;

func execute():
	$"../SM_Env_Gem_Large_Base/SM_Env_Gem_Large_Crystals".hide();
	Global.player_instance.inventory.add_item(item_data)
