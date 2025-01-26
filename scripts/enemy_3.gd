extends Node2D

func _ready() -> void:
	start_worm_cycle()

func start_worm_cycle() -> void:
	while true:
		await worm_come_out()
		await worm_bite()
		await worm_go_down()

func worm_come_out() -> void:
	$Killzone/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("up")
	await get_tree().create_timer(2.0).timeout

func worm_bite() -> void:
	$Killzone/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("bite")
	$BubbleParticlesBig2D.emitting = true
	await get_tree().create_timer(3.0).timeout

func worm_go_down() -> void:
	$AnimatedSprite2D.play_backwards("up")
	$Killzone/CollisionShape2D.disabled = true
	await get_tree().create_timer(6.0).timeout

	
	
