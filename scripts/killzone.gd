extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and timer.is_stopped():
		body.handle_damage()

func _on_timer_timeout() -> void:
	pass
	#Engine.time_scale = 1
	#get_tree().reload_current_scene()
