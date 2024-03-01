class_name NoteItem
extends HBoxContainer

@onready var item_label: Label = $Label;
@onready var item_img: TextureRect = $TextureRect;

func _ready():
	pass

func set_item(item_name: String, item_tex: Texture):
	item_img.texture = item_tex;
	item_label.text = item_name;
