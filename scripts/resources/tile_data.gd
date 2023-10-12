class_name Tile_Data
extends Resource

@export var mesh: Mesh
@export var navigation_weight: int = 0
@export var walkable = true
@export var material_override: Material

@export var random_weight: float = 0
var accumulated_weight: float = 0
