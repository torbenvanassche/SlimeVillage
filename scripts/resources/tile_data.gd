class_name Tile_Data
extends Resource

@export var tile_options: Array[PackedScene] = []
@export var navigation_weight: int = 0
@export var walkable = true
@export var ground_material: Material

@export var random_weight: float = 0
var accumulated_weight: float = 0
@export var randomize_rotation: bool = true
