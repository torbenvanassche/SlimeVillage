class_name Player
extends Node3D

var inventory: Inventory = Inventory.new();

@export var navigator: Navigator;
		
func _ready():
	Global.player_instance = self
	navigator._ready();
