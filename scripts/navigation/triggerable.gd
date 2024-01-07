class_name Triggerable
extends Node

@export var color: Color = Color(0, 0, 0)

@export var function_target: Node;
static var func_name := "execute";

signal on_entered;

func _ready():	
	if !function_target:
		for c in self.get_children():
			if c.has_method(func_name):
				function_target = c;
				
	if function_target && function_target.has_method(func_name):
		on_entered.connect(Callable(function_target, func_name))
	else: 
		print(self.get_parent().name + " has no " + func_name + " function.")
