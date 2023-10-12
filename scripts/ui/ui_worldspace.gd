class_name WorldSpaceControl
extends BoxContainer

@export var target: Node3D

func _ready():
	if !target:
		target = self.get_parent()

func _process(delta):
	reposition()

func reposition():
	position = Global.camera.unproject_position(target.global_position)
	visible = !Global.camera.is_position_behind(target.global_position)
