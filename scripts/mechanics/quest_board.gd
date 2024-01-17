extends Node

@export var folder_path: String = "res://level_pieces/posters/";
var poster_variants: Array[PackedScene] = []

func _ready():
	for file in DirAccess.get_files_at(folder_path):
		if file.get_extension() == "glb":
			poster_variants.append(load(folder_path + file))
