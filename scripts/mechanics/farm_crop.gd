extends Node3D

@export var _crop_node: Node3D
var _growth_timer: Timer

@export var _item_id: item_database.id;
@export var _auto_start: bool;
var _item: Dictionary;
var buffer: Dictionary;

func _ready():
	_crop_node.visible = false;
	_growth_timer = Timer.new()
	_growth_timer.timeout.connect(_on_grow)
	add_child(_growth_timer)
	
	if _auto_start:
		set_plant(ItemManager.get_item(_item_id))
	
func _on_grow():
	_crop_node.visible = true;
	buffer = {"name": _item.name, "amount": _item.yield}
	_item = {};
	_growth_timer.stop()
	
func execute(options: Dictionary = {}) -> Dictionary:
	print(options)
	if _growth_timer.is_stopped() && buffer:
		options.player.inventory.add_item_by_name(buffer.name, buffer.amount)
	return {};

func set_plant(item: Dictionary):
	print(item)	
	_item = item;
	_growth_timer.wait_time = item.grow_time * Settings.crop_growth_modifier;
	_growth_timer.start()
