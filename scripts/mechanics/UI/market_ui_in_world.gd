extends Node3D

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
	
	var spawner_position: Node3D = filtered.pick_random();
	var poster = get_poster();
	spawner_position.set_meta("in_use", true);
	
	var sb = Helpers.flatten_hierarchy(poster).filter(func(x): return x is StaticBody3D);
	if sb.size() == 0:
		print("No colliders found on " + poster.name)
	for collider in sb as Array[StaticBody3D]:
		collider.input_event.connect(open_window.bind(inv))
	spawner_position.add_child(poster);
	
func open_window(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1, inv: Inventory = null):
	if Input.is_action_just_pressed("mouse_left"):
		Global.ui_root.enable_ui("MARKET", Global.ui_root.get_subwindow("MARKET"), { "data": inv })
		
