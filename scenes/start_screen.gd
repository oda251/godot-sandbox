extends Control


func _on_demo_2d_pressed() -> void:
	_change_to("res://scenes/modes/demo_2d.tscn")


func _on_demo_3d_pressed() -> void:
	_change_to("res://scenes/modes/demo_3d.tscn")


func _on_physics_pressed() -> void:
	_change_to("res://scenes/modes/physics.tscn")


func _on_ui_showcase_pressed() -> void:
	_change_to("res://scenes/modes/ui_showcase.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _change_to(scene_path: String) -> void:
	var err: Error = get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("Failed to load scene %s (error %d)" % [scene_path, err])
