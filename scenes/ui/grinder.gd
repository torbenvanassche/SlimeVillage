extends Window

func _ready():
	close_requested.connect(_on_close)

func _on_close():
	Global.ui_root.disable_ui(self)
