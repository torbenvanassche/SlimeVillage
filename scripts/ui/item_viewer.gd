class_name Item
extends Node2D

var textureRect: TextureRect;
var counter: Label;

var item_name: String = "";
var item_count: int = 0;

func _ready():
	textureRect = $TextureRect;
	counter = $Label;
	
func set_item(item: Dictionary):
	item_name = item["item_name"];
	
	textureRect.set_texture(ItemManager.get_sprite(item));
	add_item();
	
func add_item():
	item_count += 1;
	counter.text = str(item_count);
