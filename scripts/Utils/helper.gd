class_name Helpers
extends Node

static func randarr_range(arr: Array):
	return arr[randi_range(0, arr.size() - 1)]
