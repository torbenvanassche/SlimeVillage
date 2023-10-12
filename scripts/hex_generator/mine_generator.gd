class_name mine_hex_generator
extends hex_grid

func generate(grid_size: Vector2i, spawnables: Array = [], item_spawn_tries = 0, spawn_fail_weight = 0):
	super(grid_size)
	
	for i in range(item_spawn_tries):
		var item = ItemManager.rand_item_weighted(spawnables, spawn_fail_weight)
		if item:
			var tile = get_open_tile()
			print(tile)
			
			var instance = MeshInstance3D.new()
			instance.mesh = ItemManager.get_mesh(item)
			instance.material_override = ItemManager.get_material(item)
			instance.position.y += 1
			tile.add_child(instance)
			tile.is_used = true
	pass
