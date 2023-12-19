class_name Triggerable
extends Node

var on_enter_visualizer = preload("res://models/prototype/sm_icon_selection_ring_012.tscn")
@export var color: Color = Color(0, 0, 0)

@export var function_target: Node;
static var func_name := "execute";

signal on_entered;

func _ready():
	var visualizer_instance = on_enter_visualizer.instantiate();
	self.get_parent().add_child.call_deferred(visualizer_instance);
	
	var copy = (visualizer_instance.get_node("SM_Icon_SelectionRing_01") as MeshInstance3D).get_active_material(0).duplicate();
	copy.albedo_color = color;
		
	(visualizer_instance.get_node("SM_Icon_SelectionRing_01") as MeshInstance3D).material_override = copy;
	
	if !function_target:
		for c in self.get_children():
			if c.has_method(func_name):
				function_target = c;
				
	if function_target && function_target.has_method(func_name):
		on_entered.connect(Callable(function_target, func_name))
		(self.get_parent() as Tile).can_generate = false;
	else: 
		print(self.get_parent().name + " has no " + func_name + " function.")
