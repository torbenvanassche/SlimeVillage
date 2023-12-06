class_name TileTrigger
extends Node3D

var items: Array = []

signal on_entered;

var area_transition_placeholder = preload("res://models/prototype/sm_icon_selection_ring_012.tscn")

func _ready():	
	var transition_placeholder = area_transition_placeholder.instantiate();
	self.get_parent().add_child(transition_placeholder);
