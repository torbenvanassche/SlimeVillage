class_name tile_item
extends Interactable

var item_data: Dictionary = {}

func init_virtual(data: Dictionary):
	item_data = data;

func _on_interact():
	$SM_Env_Gem_Large_Base/SM_Env_Gem_Large_Crystals.queue_free()
	Global.player_instance.inventory.add_item(self.item_data)
