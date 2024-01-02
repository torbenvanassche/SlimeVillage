extends GridContainer

@export var grid_size: Vector2 = Vector2(2, 2)
var rect_theme = preload("res://scenes/ui/inventory_slot.tres")

func _ready():
	self.columns = grid_size.y;
	for i in range(grid_size.x * grid_size.y):
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(50, 50);
		btn.expand_icon = true;
		btn.theme = rect_theme;	
		self.add_child(btn)
		
		btn.pressed.connect(_add_selected_item.bind(btn))
		
func _add_selected_item(btn: Button):
	if Global.player_instance.inventory.ui.selected_item:
		Global.player_instance.inventory.remove_item(Global.player_instance.inventory.ui.selected_item, 1);
		btn.icon = Global.player_instance.inventory.ui.selected_item.sprite;
