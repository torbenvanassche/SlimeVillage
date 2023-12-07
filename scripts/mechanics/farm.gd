extends Node3D

@export var farm_plots: Array[Node3D]
var growth_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	for resource in farm_plots:
		resource.visible = false

	growth_timer = Timer.new()
	growth_timer.wait_time = Settings.crop_growth_speed
	growth_timer.timeout.connect(_on_grow)
	add_child(growth_timer)
	growth_timer.start()
	
func _on_grow():
	var r = Helpers.randarr_range(farm_plots)
	r.visible = true
	
	if farm_plots.all(func(x): return x.visible):
		growth_timer.stop()
