extends Control


func _on_back_pressed() -> void:
	var err: Error = get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	if err != OK:
		push_error("Failed to return to start screen (error %d)" % err)
