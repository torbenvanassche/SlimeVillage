class_name itemized_hex_grid
extends hex_grid

func generate(grid_size: Vector2i, spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0):
	super(grid_size)
	
	Global.player_instance.set_position_to_current_tile(get_tile(ceil(Settings.mine_grid_size.x / 2.0)))
	
	for i in range(item_spawn_tries):
		var item = ItemManager.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			var tile: Node3D = replace_tile(get_open_tile(Global.player_instance.current_tile), ItemManager.get_scene(item).instantiate())
			tile.is_used = true

	_init_pathfinder()
