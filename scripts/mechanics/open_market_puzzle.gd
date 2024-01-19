extends StaticBody3D

func execute(options: Dictionary):
	print(Global.ui_root, Global.ui_root.puzzle_ui)
	Global.ui_root.puzzle_ui.show();
	var ui = Global.ui_root.puzzle_ui.get_node("InventoryPanel/Inventory") as InventoryUI;
	ui.update(options.player.inventory.data)
