class_name ItemViewController
extends WorldSpaceControl

var item_scene: PackedScene = preload("res://scenes/ui/item_viewer.tscn")
 
func add_item(item: Dictionary):
	for child in self.get_children():
		if child.get_meta("item_name") == item["name"]:
			var label = child.get_node("Label")
			label.text = str(int(label.text) + 1)
			return
	
	var item_instance: Control = item_scene.instantiate()
	var label = item_instance.get_node("Label")
	label.text = str(1)	
	
	item_instance.get_node("TextureRect").set_texture(load("res://resources/items/" + item["relative_path"]))
	item_instance.set_meta("item_name", item["name"])
	self.add_child(item_instance)
	item_instance.get_node("Label").text = str(1)
