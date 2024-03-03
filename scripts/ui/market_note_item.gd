class_name NoteItem
extends Control

@export var item_label: Label;
@export var item_img: TextureRect;

func set_item(item_name: String, item_count: int, item_tex: Texture):
	item_img.texture = item_tex;
	item_label.text = item_name + ": " + str(item_count);
