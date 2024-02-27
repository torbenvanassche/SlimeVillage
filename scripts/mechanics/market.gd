extends Node

var spawn_timer: Timer

var current_orders: Array[Inventory];
@onready var available_items := ItemManager.get_by_property("available", true);

@export var spawn_delay = 1;
@export var max_orders = 1;
@onready var market_window := Global.ui_root.get_subwindow("MARKET");
@export var amount_per_spawn = 1;

signal item_spawned(inv: Inventory);

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1
	spawn_timer.timeout.connect(_on_spawn)
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn():
	var inv = Inventory.new();
	for a in amount_per_spawn:
		var item = _generate_item();
		inv.add_item(item, 1);
	item_spawned.emit(inv)

	if current_orders.size() >= max_orders:
		spawn_timer.stop()
		
func _generate_item():
	var generated_item = Helpers.rand_item_weighted(available_items)
	return ItemManager.get_item(generated_item.id)
