class_name Triggerable
extends Node

var on_enter_visualizer = preload("res://models/prototype/sm_icon_selection_ring_012.tscn")

@export var function_target: Node;
static var func_name := "execute";

signal on_entered;

func _ready():
	var visualizer_instance = on_enter_visualizer.instantiate();
	self.get_parent().add_child.call_deferred(visualizer_instance);
	
	if !function_target:
		for c in self.get_children():
			if c.has_method(func_name):
				function_target = c;
				
	if function_target && function_target.has_method(func_name):
		on_entered.connect(Callable(function_target, func_name))
		(self.get_parent() as Tile).is_used = true;
	else: 
		print(self.get_parent().name + " has no " + func_name + " function.")
