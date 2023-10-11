extends ItemContainer

@export var item_name: String

# Called when the node enters the scene tree for the first time.
func _init():
	item = ItemManager.get_item_by_name(item_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
