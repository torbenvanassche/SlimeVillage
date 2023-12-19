extends Node

var item_data: Dictionary;
var can_interact: bool = true;

func execute():
	if can_interact == false:
		return;
	
	$"../SM_Env_Gem_Large_Base/SM_Env_Gem_Large_Crystals".hide();
	Global.player_instance.inventory.add_item(item_data)
	can_interact = false;
