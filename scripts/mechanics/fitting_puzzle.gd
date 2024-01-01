extends GridContainer

@export var grid_size: Vector2 = Vector2(2, 2)

func _ready():
	self.columns = grid_size.y;
	for i in range(grid_size.x * grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		self.add_child(btn)
