extends HTTPRequest

func get_data(query: String) -> void:
	var url := "https://pokeapi.co/api/v2/" + query
	request_completed.connect(_on_response)
	request(url)
		
func _on_response(result, response_code, headers, body):
	print(body.get_string_from_utf8())
