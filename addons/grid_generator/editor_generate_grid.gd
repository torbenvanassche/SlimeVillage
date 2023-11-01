@tool
extends EditorPlugin
	
func _ready():
	get_viewport().files_dropped.connect(_on_drop)
	print("ready")
	
func _on_drop(files):
	print(files)
