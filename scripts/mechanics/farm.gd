extends TileTrigger

@export var growable_resources: Array[Node3D]
var growth_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	for resource in growable_resources:
		resource.visible = false

	growth_timer = Timer.new()
	growth_timer.wait_time = Settings.crop_growth_speed
	growth_timer.timeout.connect(_on_grow)
	add_child(growth_timer)
	growth_timer.start()
	
	items = JSON_HELPER.get_array_by_property(ItemManager.items, "location", "farm").filter(func(x): return x["available"] == true)
	
func _on_grow():
	var r = Helpers.randarr_range(growable_resources)
	r.visible = true
	
	if growable_resources.all(func(x): return x.visible):
		growth_timer.stop()
		
func _entered():
	GlobalEvents.resource_location_interaction.emit(ItemManager.rand_item_weighted(items))
	pass
