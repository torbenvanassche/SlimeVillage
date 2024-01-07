extends TileBase

@export var can_generate = false;

func add_top(item_data: Dictionary):
	var spawned = ItemManager.get_scene(item_data).instantiate()
	if spawned is Interactable:
		spawned.initialize(item_data);
			
		add_child(spawned)
		walkable_in_scene = false
		can_generate = false
