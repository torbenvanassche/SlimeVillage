extends Control

func _ready():
	_deferred_ready.call_deferred()
	pass

func _deferred_ready():
	$VBoxContainer/Resume.button_up.connect(func(): pause(false))
	$VBoxContainer/Quit.button_up.connect(func(): get_tree().quit())
	$VBoxContainer/Settings.button_up.connect(_open_settings)

func _open_settings():
	Global.ui_root.enable_ui(Global.ui_root.get_subwindow("SETTINGS"), true)
	self.visible = false;

func pause(pause_game = true):
	get_tree().paused = pause_game
	if get_tree().paused:
		Global.ui_root.enable_ui(self, true)
	else:
		Global.ui_root.disable_ui(self, false)
