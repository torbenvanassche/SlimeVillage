class_name Helpers
extends Node

static func randarr_range(arr: Array):
	return arr[randi_range(0, arr.size() - 1)]

static func arrays_have_same_content(array1: Array, array2: Array):
	if array1.size() != array2.size(): 
		return false
	for item in array1:
		if !array2.has(item): 
			return false
		if array1.count(item) != array2.count(item): 
			return false
	return true
