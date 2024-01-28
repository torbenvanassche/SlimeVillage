extends Node

#Farm
var crop_growth_modifier = 0.1

#Navigation mode controller
var input_mode: Global.NAV_STYLE = Global.NAV_STYLE.WASD;

func set_input_mode(style: Global.NAV_STYLE):
	input_mode = style;
	
#camera sensitivity
var camera_rotation_sensitivity = 0.01;
var camera_zoom_sensitivity = 0.5;
