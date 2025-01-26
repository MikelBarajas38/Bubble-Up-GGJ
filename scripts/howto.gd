extends Control

var slide = 0
var screens = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screens = [$S1, $S2, $S3, $S4, $S5]
	screens[0].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	screens[slide].visible = false
	slide += 1
	if slide >= screens.size():
		await Transition.fade_out()
		get_tree().change_scene_to_file("res://scenes/level1.tscn")
		Transition.fade_in()
		return
	screens[slide].visible = true


func _on_prev_button_pressed() -> void:
	screens[slide].visible = false
	slide -= 1
	if slide < 0:
		slide = screens.size() - 1
	screens[slide].visible = true
