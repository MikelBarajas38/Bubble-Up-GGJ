extends Area2D

func _on_body_entered(body):
	if body.name == ("Player"):
		body.add_bubble()
	queue_free()
