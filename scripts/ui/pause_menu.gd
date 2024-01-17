extends Control

func _ready():
	_deferred_ready.call_deferred()
	pass

func _deferred_ready():
	$VBoxContainer/Resume.button_up.connect(func(): pause(false))
	$VBoxContainer/Quit.button_up.connect(func(): get_tree().quit())

func pause(pause_game = true):
	get_tree().paused = pause_game
	if get_tree().paused:
		self.show()
	else:
		self.hide()
