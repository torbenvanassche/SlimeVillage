class_name UIManager
extends Node

@export var puzzle_ui: Control

func _ready():
	Global.ui_root = self;
