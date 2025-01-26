extends CharacterBody2D

@export var speed = 500
@export var jump_speed = -800
@export var acceleration = 80
@export var friction = 20
@export var base_gravity = 1200
@export var max_bubble_count = 3

var bubble_count = Global.bubble_count

var jumping = false
var dead = false
var jump_count = 0

var gravity = base_gravity
var max_fall_speed = 1000

var coyote_frames = 5
var coyote = false
var last_floor = false

var collision_shapes = []
var invulnerable = false

var stretch = false
var squash = false

func _ready():
	collision_shapes = [$CollisionBubble1, $CollisionBubble2, $CollisionBubble3]
	$CoyoteTimer.wait_time = coyote_frames / 60.0
	handle_bubble_change()

func handle_bubble_change():
	Global.bubble_count = bubble_count
	for shape in collision_shapes:
		shape.set_deferred("disabled", true)
	collision_shapes[bubble_count-1].set_deferred("disabled", false)
	$BubbleBackSprite2D.play(str(bubble_count))
	$BubbleFrontSprite2D.play(str(bubble_count))

func handle_death():
	dead = true
	Global.bubble_count = 0
	Engine.time_scale = 0.5
	for shape in collision_shapes:
		shape.set_deferred("disabled", true)
	$BubbleBackSprite2D.set_deferred("visible", false)
	$BubbleFrontSprite2D.set_deferred("visible", false)
	$DeathTimer.start()

func handle_damage():

	if invulnerable:
		return

	squash = true

	if bubble_count > 1:
		pop_bubble()
		invulnerable = true
		velocity.y = jump_speed * 0.5
		if velocity.x > 0:
			velocity.x = -speed * 4
		else:
			velocity.x = speed * 4
		$DamageTimer.start()
	else:
		velocity.y = jump_speed
		if velocity.x > 0:
			velocity.x = -speed * 4
		else:
			velocity.x = speed * 4
		handle_death()

func pop_bubble():
	$PopParticles2D.emitting = true
	bubble_count -= 1
	if bubble_count < 1:
		bubble_count = 0
		handle_death()
	handle_bubble_change()

func add_bubble():
	$AddParticles2D.emitting = true
	bubble_count += 1
	if bubble_count > 3:
		bubble_count = 3
	handle_bubble_change()

func handle_input(delta):

	var direction = Input.get_axis("move_left", "move_right")

	if direction and !invulnerable and !dead:
		velocity.x = lerp(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	if Input.is_action_just_pressed("bubble"):
		pop_bubble()

	if Input.is_action_just_pressed("jump") and !invulnerable and !dead:
		if is_on_floor() or coyote:
			velocity.y = jump_speed
			jump_count = jump_count + 1
			jumping = true
			stretch = true
			$JumpParticles2D.emitting = true
		elif jump_count < 2:
			velocity.y = jump_speed
			pop_bubble()
			jump_count = jump_count + 1
			stretch = true
			$JumpParticles2D.emitting = true
	
	if !Input.is_action_pressed("jump") and jumping:
		gravity = base_gravity * 2.5
	else:
		gravity = base_gravity

	if !Input.is_action_just_pressed("jump") and is_on_floor() and jumping:
		jumping = false
		jump_count = 0
		squash = true
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()

	last_floor = is_on_floor()

func handle_animation(delta):

	$WalkParticles2D.emitting = false
	
	if velocity.x > 0 and !dead and !invulnerable:
		$AnimatedSprite2D.flip_h = false
		$BubbleBackSprite2D.flip_h = false
		$BubbleFrontSprite2D.flip_h = false
	
	if velocity.x < 0 and !dead and !invulnerable:
		$AnimatedSprite2D.flip_h = true
		$BubbleBackSprite2D.flip_h = true
		$BubbleFrontSprite2D.flip_h = true

	if invulnerable:
		$AnimatedSprite2D.play("damage")
	elif dead:
		$AnimatedSprite2D.play("dead")
	elif is_on_floor() and !jumping:
		var moving = Input.get_axis("move_left", "move_right")
		if moving:
			$AnimatedSprite2D.play("run")
			$WalkParticles2D.emitting = true
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y < 0:
			if jump_count < 2:
				$AnimatedSprite2D.play("up")
			else:
				$AnimatedSprite2D.play("upup")
		else:
			$AnimatedSprite2D.play("down")
			stretch = false
	
	if stretch:
		$AnimatedSprite2D.scale = Vector2(0.9, 1.1)
		$BubbleBackSprite2D.scale = Vector2(0.9, 1.1)
		$BubbleFrontSprite2D.scale = Vector2(0.9, 1.1)
	
	if squash:
		$AnimatedSprite2D.scale = Vector2(1.3, 0.9)
		$BubbleBackSprite2D.scale = Vector2(1.3, 0.9)
		$BubbleFrontSprite2D.scale = Vector2(1.3, 0.9)
		$JumpParticles2D .emitting = true
		squash = false

	$AnimatedSprite2D.scale.x = move_toward($AnimatedSprite2D.scale.x, 1, delta * 3)
	$AnimatedSprite2D.scale.y = move_toward($AnimatedSprite2D.scale.y, 1, delta * 3)
	$BubbleBackSprite2D.scale.x = move_toward($BubbleBackSprite2D.scale.x, 1, delta * 3)
	$BubbleBackSprite2D.scale.y = move_toward($BubbleBackSprite2D.scale.y, 1, delta * 3)
	$BubbleFrontSprite2D.scale.x = move_toward($BubbleFrontSprite2D.scale.x, 1, delta * 3)
	$BubbleFrontSprite2D.scale.y = move_toward($BubbleFrontSprite2D.scale.y, 1, delta * 3)

func _physics_process(delta):

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	handle_input(delta)
	move_and_slide()
	handle_animation(delta)

func _on_coyote_timer_timeout():
	coyote = false

func _on_damage_timer_timeout():
	invulnerable = false

func _on_death_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
