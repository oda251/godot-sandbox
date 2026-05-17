extends Control


func _on_shooter_pressed() -> void:
	_change_to("res://scenes/modes/shooter/shooter.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _change_to(scene_path: String) -> void:
	var err: Error = get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("Failed to load scene %s (error %d)" % [scene_path, err])
