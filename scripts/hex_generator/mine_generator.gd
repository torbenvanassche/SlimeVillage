class_name mine_hex_generator
extends hex_grid

func generate(grid_size: Vector2i, spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0):
	super(grid_size)
	
	for i in range(item_spawn_tries):
		var item = ItemManager.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			var tile: Node3D = replace_tile(get_open_tile(Global.player_instance.current_tile), ItemManager.get_scene(item).instantiate())
			tile.rotate_y(deg_to_rad(randi_range(0, 6) * 60))
			tile.is_used = true

	_init_pathfinder()
	Global.player_instance.find_location()
