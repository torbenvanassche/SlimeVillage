extends Node

@export var trigger: TileTrigger;
@export var transition_info: Node;

static var func_name := "execute"

func _ready():
	if transition_info && transition_info.has_method(func_name):
		trigger.on_entered.connect(transition_info.execute)
	else: 
		print(transition_info.to_string() + "has no function named " + func_name)
