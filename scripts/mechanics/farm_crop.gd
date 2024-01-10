extends Node3D

@export var _crop_node: Node3D
var _growth_timer: Timer

@export var _item_id: String;
var _item: Dictionary;

func _ready():
	_growth_timer = Timer.new()
	_growth_timer.timeout.connect(_on_grow)
	add_child(_growth_timer)
	
func _on_grow():
	_crop_node.visible = true;
	_growth_timer.stop()

func set_plant(item: Dictionary):
	_crop_node.visible = false;
	
	_growth_timer.wait_time = item.grow_time * Settings.crop_growth_modifier;
	_growth_timer.start()
