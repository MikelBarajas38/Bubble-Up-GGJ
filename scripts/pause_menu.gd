extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event):
	if Input.is_action_just_pressed("pause"):
		print("Pausado")
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
