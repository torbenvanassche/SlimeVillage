extends Node

@export var _poster_packed: Array[PackedScene] = [];
var _spawn_positions: Array[Node] = [];
@export var market_generator: MarketGenerator;

func get_poster():
	return _poster_packed.pick_random().instantiate();

func _ready():
	market_generator.item_spawned.connect(_spawn_item);
	_spawn_positions = get_children();
	
func _spawn_item(inv: Inventory):
	var filtered = _spawn_positions.filter(func(x): return !x.get_meta("in_use", false));
	if filtered.size() == 0:
		return;
	
	var spawned: Node3D = filtered.pick_random();
	var poster = get_poster();
	spawned.set_meta("in_use", true);
	spawned.set_meta("item", inv);
	print(spawned.get_child(0, true))
	spawned.add_child(poster);
