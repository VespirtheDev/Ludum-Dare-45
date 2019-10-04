extends KinematicBody2D

signal life_changed
signal dead

var state = "Idle"
var next_anim

export (int, 1, 5) var life

export (float) var run_speed = 350
export (float) var crawl_speed = 150
export (float) var jump_speed = -305
export (float) var gravity = 750

var move_speed = 150

var velocity = Vector2()

export (int) var max_jumps = 2
var jump_count = 0

func _ready():
	yield(get_tree().create_timer(0.3), "timeout")
	change_state("Idle")
	emit_signal("life_changed", life)

func change_state(new_state):
	match new_state:
		"Idle":
			next_anim = "Idle"
			$StepTimer.stop()
			print("Idle")
		"Run":
			next_anim = "Run"
			$StepTimer.start()
			move_speed = run_speed
		"Crouch":
#			next_anim = "Crouch"
			print("Crouch")
		"Crawl":
#			next_anim = "Crawl"
			move_speed = crawl_speed
			print("Crawl")
		"Hurt":
			$StepTimer.stop()
			next_anim = "Hurt"
#			$Sounds/HurtSound.play()
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1 
			emit_signal("life_changed", life)
			$ImmortalDuration.start()
			if life <= 0:
				change_state("Dead")
		"Jump":
			$StepTimer.stop()
			next_anim = "jump_up"
			jump_count = 1
#			$Sounds/JumpSound.play()
		"Dead":
			set_physics_process(false)
			emit_signal("dead")
			hide()
	
	state = new_state

func get_input():
	if state == "Hurt":
		return
	
	velocity.x = 0
	
	# Store inputs into variables for ease of access
	var right = Input.is_action_pressed("Right")
	var left = Input.is_action_pressed("Left")
	var jump = Input.is_action_just_pressed("Jump")
	var crouch = Input.is_action_just_pressed("Crouch")
	
	# Detect directional input, change velocity and sprite direction to match
	if right:
		velocity.x = move_speed
		$Sprite.flip_h = false
		
	if left:
		velocity.x = -move_speed
		$Sprite.flip_h = true
	
	if crouch:
		if state in ["Crawl", "Crouch"]:
			change_state("Idle")
		else:
			change_state("Crouch")
	
	if state == "Crouch":
		if velocity.x != 0:
				change_state("Crawl")
	if state == "Crawl":
		if velocity.x == 0:
			change_state("Crouch")
	
	if jump and can_jump():
		change_state("Jump")
		velocity.y = jump_speed
	elif jump and state == "Jump" and jump_count < max_jumps:
		next_anim = "jump_up"
		velocity.y = jump_speed / 1.5
		jump_count += 1
	
	if state in ["Idle"] and velocity.x != 0:
		change_state("Run")
		
	if state == "Run" and velocity.x == 0:
		change_state("Idle")
	
	if state in ["Idle", "Run"] and !is_on_floor():
		change_state("Jump")

func start(pos):
	position = pos

func hurt():
	if not state in ["Hurt", "Dead"]:
		change_state("Hurt")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if state != "Hurt":
		get_input()
	
	if next_anim != $CharAnim.current_animation:
		$CharAnim.play(next_anim)
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if position.y > 1000:
		change_state("Dead")
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Danger":
			velocity.y = -200
			hurt()
		if collision.collider.is_in_group("Enemies"):
			var player_feet = (position+$BodyCollider.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
				jump_count = max_jumps
			else:
				hurt()
	
	if state == "Jump" and velocity.y > 0:
		next_anim = "Fall"
	if state == "Jump" and is_on_floor():
		change_state("Idle")

func end_immortality():
	change_state("Idle")

func play_step_sound():
	pass
#	$Sounds/StepSound.play()

func can_jump():
	if not state in ["Crouch", "Crawl"]:
		if is_on_floor():
			return true
	
	return false


