class_name UIManager
extends Node

@export var puzzle_ui: Control
@export var player_inventory: FlowContainer;

@export var folder_path: String = "res://level_pieces/posters/";
var poster_variants: Array[PackedScene] = []

func _init():
	Global.ui_root = self;
	for file in DirAccess.get_files_at(folder_path):
		if file.get_extension() == "glb":
			poster_variants.append(load(folder_path + file))
