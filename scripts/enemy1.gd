extends Node2D

var speed = 200
var can_move = true

func _ready() -> void:
	$AnimatedSprite2D.play("run")
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)

func _process(delta: float) -> void:
	if !$RayCast2D.is_colliding() and can_move:
		can_move = false
		speed = -speed
		scale.x = -scale.x
		$Timer.start()

	if can_move:
		position.x += speed * delta

func _on_timer_timeout() -> void:
	can_move = true
	
