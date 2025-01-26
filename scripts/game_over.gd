extends CanvasLayer

func _on_retry_pressed() -> void:
	Global.bubble_count = 2
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()