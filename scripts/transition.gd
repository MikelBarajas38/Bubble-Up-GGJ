extends CanvasLayer

func fade_out():
	visible = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	visible = false

func fade_in():
	visible = true
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	visible = false
