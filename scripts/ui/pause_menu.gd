extends Control

func _ready():
	_deferred_ready.call_deferred()
	pass

func _deferred_ready():
	$VBoxContainer/Resume.button_up.connect(func(): Global.manager.pause(false))
	$VBoxContainer/Quit.button_up.connect(func(): get_tree().quit())
