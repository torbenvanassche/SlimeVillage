extends Control

var window: DraggableControl;

func _ready():
	_deferred_ready.call_deferred()
	pass

func _deferred_ready():
	$Resume.button_up.connect(func(): Global.ui_root.pause(false))
	$Quit.button_up.connect(func(): get_tree().quit())
	$Settings.button_up.connect(_open_settings)

func _open_settings():
	Global.ui_root.enable_ui(Global.ui_root.get_subwindow("SETTINGS"), true, {"hide": window})
