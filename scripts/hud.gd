extends CanvasLayer

func _process(delta: float) -> void:
	$B1.visible = false
	$B2.visible = false
	$B3.visible = false
	match Global.bubble_count:
		1:
			$B1.visible = true
		2:
			$B1.visible = true
			$B2.visible = true
		3:
			$B1.visible = true
			$B2.visible = true
			$B3.visible = true
		_:
			pass
