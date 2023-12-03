class_name Interactable
extends Node

signal interacted(data: Dictionary)

var item_data: Dictionary = {}

func initialize(data: Dictionary):
	$StaticBody3D.input_event.connect(_on_interact)
	item_data = data;

func _on_interact(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left"):
		Global.player_instance.navigator.try_move(self.get_parent(), true)
		if Global.player_instance.navigator.is_adjacent(self.get_parent()):
			print(item_data);
