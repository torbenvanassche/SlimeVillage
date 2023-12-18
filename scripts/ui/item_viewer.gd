class_name ItemViewer
extends Control

var textureRect: TextureRect;
var counter: Label;

var item_name: String = "";
var item_count: int = 0;

func _ready():
	textureRect = $TextureRect;
	counter = $Label;
	
func set_item(item: Dictionary):
	item_name = item["name"];
	item_count = item["count"];
	
	textureRect.set_texture(ItemManager.get_sprite(item));
