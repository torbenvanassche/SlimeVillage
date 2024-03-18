class_name ContextMenuItem
extends Node

var id: String;
var function: Callable;
var idx: int = -1;

func _init(i: String, f: Callable):
	id = i;
	f = function;
