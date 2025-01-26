extends Area2D

@export var next_level: String

func _on_body_entered(body: Node2D) -> void:
	print("entre")
	change_level()

# Cambiar al siguiente nivel
func change_level():
	Global.current_level = Global.current_level + 1
	get_tree().paused = true
	await Transition.fade_out()
	get_tree().paused = false
	get_tree().change_scene_to_file(next_level)
	Transition.fade_in()
	
