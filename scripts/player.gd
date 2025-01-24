extends CharacterBody2D

@export var speed = 500
@export var jump_speed = -800
@export var acceleration = 80
@export var friction = 20
@export var base_gravity = 1200
@export var max_bubble_count = 3

var jumping = false
var dead = false
var jump_count = 0

var gravity = base_gravity
var max_fall_speed = 1000

var coyote_frames = 5
var coyote = false
var last_floor = false

var bubble_count = 1
var collision_shapes = []

func _ready():
	collision_shapes = [$CollisionBubble1, $CollisionBubble2, $CollisionBubble3]
	$CoyoteTimer.wait_time = coyote_frames / 60.0
	handle_bubble_change()

func handle_bubble_change():
	for shape in collision_shapes:
		shape.disabled = true
	collision_shapes[bubble_count-1].disabled = false

func handle_death():
	pass

func handle_damage():
	if bubble_count > 0:
		pop_bubble()
	else:
		dead = true

func pop_bubble():
	bubble_count -= 1
	if bubble_count < 1:
		bubble_count = 1
		dead = true
	handle_bubble_change()

func add_bubble():
	bubble_count += 1
	if bubble_count > max_bubble_count:
		bubble_count = max_bubble_count
	handle_bubble_change()

func handle_input(delta):

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	if Input.is_action_just_pressed("bubble"):
		add_bubble()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote:
			velocity.y = jump_speed
			jump_count = jump_count + 1
			jumping = true
		elif jump_count < 1:
			velocity.y = jump_speed
			pop_bubble()
			jump_count = jump_count + 1
	
	if jumping and !Input.is_action_pressed("jump"):
		gravity = base_gravity * 2.5
	else:
		if velocity.y == 0:
			gravity = base_gravity * 0.5
		else:
			gravity = base_gravity

	if is_on_floor() and jumping:
		jumping = false
		jump_count = 0
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()

func handle_animation():
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	if dead:
		$AnimatedSprite2D.play("dead")
	elif is_on_floor() and !jumping:
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

	last_floor = is_on_floor()
	
	if dead:
		handle_death() 

	move_and_slide()
	handle_animation()

func _on_coyote_timer_timeout():
	coyote = false
