extends Control

var settings_screen: Control;

func _ready():
	_deferred_ready.call_deferred()
	pass

func _deferred_ready():
	$VBoxContainer/Resume.button_up.connect(func(): pause(false))
	$VBoxContainer/Quit.button_up.connect(func(): get_tree().quit())
	$VBoxContainer/Settings.button_up.connect(func(): settings_screen.visible = true)

func pause(pause_game = true):
	get_tree().paused = pause_game
	if get_tree().paused:
		self.show()
	else:
		self.hide()
