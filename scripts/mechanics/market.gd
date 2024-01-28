extends Node3D

var spawn_timer: Timer
var game_over_timer: Timer
var can_game_over: bool = false

@onready var current_orders: Inventory = Inventory.new()
var available_items: Dictionary = {}

@export var max_item_count = 10
@export var market_inventory_ui: InventoryUI;

signal item_spawned(id: String);

func _ready():
	available_items = ItemManager.get_by_property("available", true)
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1
	spawn_timer.timeout.connect(_on_spawn)
	add_child(spawn_timer)
	spawn_timer.start()
	
	if(can_game_over):
		game_over_timer = Timer.new()
		game_over_timer.wait_time = Settings.item_grace_period_on_buffer_full
		game_over_timer.timeout.connect(Global.game_over)
		add_child(game_over_timer)

func _on_spawn():
	var generated_item = Helpers.rand_item_weighted(available_items)
	self._add_item(ItemManager.get_item(generated_item.id));
	item_spawned.emit(generated_item.id)

	if current_orders.get_item_count() >= max_item_count:
		spawn_timer.stop()
		
		#control potential game over state
		if can_game_over:
			game_over_timer.start()
	
func _add_item(item: Dictionary):
	current_orders.add_item(item, false)
	
func _remove_item(item: Dictionary, count: int):
	current_orders.remove_item(item, count)
