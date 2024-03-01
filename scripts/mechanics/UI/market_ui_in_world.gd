extends Node

@export var _poster_packed: Array[PackedScene] = [];
var _spawn_positions: Array[Node] = [];
@export var market_generator: MarketGenerator;

func get_poster():
	return _poster_packed[0].instantiate();
	#return _poster_packed.pick_random().instantiate();

func _ready():
	market_generator.item_spawned.connect(_spawn_item);
	_spawn_positions = get_children();
	
func _spawn_item(inv: Inventory):
	var filtered = _spawn_positions.filter(func(x): return !x.get_meta("in_use", false));
	if filtered.size() == 0:
		return;
	
	var spawner_position: Node3D = filtered.pick_random();
	var poster = get_poster();
	spawner_position.set_meta("in_use", true);
	spawner_position.set_meta("item", inv);
	print(poster.get_child(0, true).get_child(0, true));
	spawner_position.add_child(poster);
