extends Node2D

@export var scales: Array = [12.0, 30.0] 
@export var wait_time: float = 1.0 # Tiempo de espera entre fases

var current_phase: int = 0 
var growing: bool = true
var playing_transition: bool = false

@onready var collision_shape: CollisionShape2D = $Killzone/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = wait_time
	timer.one_shot = true
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	if not animated_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	_start_phase_animation()

func _on_animation_finished() -> void:
	if playing_transition:
		playing_transition = false
		var target_scale = scales[current_phase]
		if collision_shape:
			collision_shape.scale = Vector2(target_scale, target_scale)
		
		if growing:
			current_phase = 0
		else:
			current_phase = 1
			$BubbleParticlesSmall2D.emitting = true
		growing = not growing
		
		timer.start()
	else:
		_start_transition_animation()

func _on_timer_timeout():
	_start_phase_animation()

func _start_phase_animation():
	$BubbleParticlesBig2D.emitting = true
	if growing:
		animated_sprite.play("start")
	else:
		animated_sprite.play("end")

func _start_transition_animation():
	playing_transition = true
	if growing:
		animated_sprite.play("trans")
	else:
		animated_sprite.play_backwards("trans")
