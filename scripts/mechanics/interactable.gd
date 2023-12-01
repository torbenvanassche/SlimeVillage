class_name Interactable
extends Node

signal interacted(data: Dictionary)

var item_data: Dictionary = {}

func initialize(data: Dictionary):
	$StaticBody3D.input_event.connect(_on_interact)
	item_data = data;
	pass

func _on_interact(_camera, _event, _pos, _normal, _shape_idx):
	if Input.is_action_just_pressed("mouse_left"):
		if Global.player_instance.try_interact(self.get_parent(), true):
			Global.player_instance.inventory.add_item(item_data);
