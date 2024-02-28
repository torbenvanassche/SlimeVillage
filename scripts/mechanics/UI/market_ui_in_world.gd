extends Node

@export var _poster_packed: Array[PackedScene] = [];
@export var market_generator: MarketGenerator;

func get_poster():
	return _poster_packed.pick_random().instantiate();

func _ready():
	market_generator.item_spawned.connect(_spawn_item)
	
func _spawn_item(inv: Inventory):
	print(inv)
	pass
