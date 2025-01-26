extends Area2D

@export var next_level: String

func _on_body_entered(body: Node2D) -> void:
	print("entre")
	change_level()

# Cambiar al siguiente nivel
func change_level():
	get_tree().change_scene_to_file(next_level)
