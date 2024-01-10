extends Node

#Market
var item_spawn_speed = 10
var item_grace_period_on_buffer_full = 10

#Mine controllers
var mine_grid_size: Vector2i = Vector2i(5, 5)
var mine_amount_to_spawn: int = 4
var mine_chance_to_fail: int = 1

#Farm controllers
var forest_grid_size: Vector2i = Vector2i(5, 10)

#Farm
var crop_growth_modifier = 1

var input_mode: Global.NAV_STYLE = Global.NAV_STYLE.CLICK;

func set_input_mode(style: Global.NAV_STYLE):
	input_mode = style;
