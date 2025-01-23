extends CharacterBody2D

@export var speed = 500
@export var jump_speed = -800
@export var acceleration = 80
@export var friction = 20
@export var base_gravity = 1200

var jumping = false
var dead = false

var gravity = base_gravity
var max_fall_speed = 1000

var coyote_frames = 6
var coyote = false
var last_floor = false

func _ready():
	$CoyoteTimer.wait_time = coyote_frames / 60.0

func handle_input(delta):

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = jump_speed
		jumping = true
	
	if jumping and !Input.is_action_pressed("jump"):
		gravity = base_gravity * 2.5
	else:
		if velocity.y == 0:
			gravity = base_gravity * 0.5
		else:
			gravity = base_gravity

func handle_animation():

	if is_on_floor() and !jumping:
		var moving = Input.get_axis("move_left", "move_right")
		if moving:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.play("up")
		else:
			$AnimatedSprite2D.play("down")
	
func _physics_process(delta):

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	handle_input(delta)

	if is_on_floor() and jumping:
		jumping = false
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	last_floor = is_on_floor()

	move_and_slide()
	handle_animation()

func _on_coyote_timer_timeout():
	coyote = false
