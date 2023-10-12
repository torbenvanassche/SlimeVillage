class_name ItemDisplay
extends WorldSpaceControl

# Called when the node enters the scene tree for the first time.
func _ready():
	if !target:
		target = self.get_parent().get_parent()

func _process(_delta):
	reposition()
	pass
