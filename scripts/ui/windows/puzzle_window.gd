extends Node

@onready var window: Window = $"..";

func on_enable():
	window.inventory.set_controller(Global.player_instance.inventory);
