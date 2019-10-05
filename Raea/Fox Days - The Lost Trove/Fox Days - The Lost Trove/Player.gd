extends KinematicBody2D

signal life_changed
signal dead

var state = "Idle" #Current game state
var anim #Current animation being played
var next_anim #New animation to be played

var velocity = Vector2()
var textures = {"Player_Textures": {"Current": "empty","young": "res://assets/sprites/Player/young.png", "advent": "res://assets/sprites/Player/advent.png","advent_sword": "res://assets/sprites/Player/advent_sword.png","old_advent": "res://assets/sprites/Player/old_advent.png","old_advent_sword": "res://assets/sprites/Player/old_advent_sword.png"},
                "SoundFX": {"Run_Footsteps": "res://assets/audio/Sound Effects/walk_steps.ogg", "Sprint_Footsteps": "res://assets/audio/Sound Effects/run_steps.ogg", "Jump": "res://assets/audio/Sound Effects/jump.ogg", "Landing": "res://assets/audio/Sound Effects/landing.ogg", "Climbing": "res://assets/audio/Sound Effects/climbing.ogg"}
               }

export (float) var run_speed
export (float) var sprint_speed
export (float) var crawl_speed
export (float) var climb_speed
export (float) var jump_speed = 150
var move_speed = 130

export (float) var gravity = 680
var jump_count = 0
var jump_count_max = 1

export (bool) var can_run_right = true
export (bool) var can_run_left = false
export (bool) var can_jump = false
export (bool) var can_crouch = false
export (bool) var can_crawl = false
export (bool) var can_climb = false

func _ready():
	set_state("Idle") #Changes state to Idle by default
	set_physics_process(true)

#Handles changing the player textures
func set_sprite(new_texture):
	$Sprite.texture = load(textures.Player_Textures[new_texture])
	textures.Player_Textures.Current = new_texture

#Handles changing the game state
func set_state(new_state):
	match new_state: #Matches the state 
		"Idle":
#			$SoundFX/Footsteps.stop()
			next_anim = "Idle"
		
		"Run":
			move_speed = run_speed
#			$SoundFX/Footsteps.play()
			next_anim = "Run"
		
		"Sprint":
			move_speed = sprint_speed
			next_anim = "Run"
#			$SoundFX/Footsteps.play()
		
		"Jump":
			next_anim = "Jump"
		
		"Fall":
			next_anim = "Fall"
		
		"Climb":
			move_speed = climb_speed
			next_anim = "Climb"
		
		"Crouch":
			next_anim = "Crouch"
		
		"Crawl":
			move_speed = crawl_speed
			next_anim = "Crawl"
		
		"WallSlide":
			if $RightSideCheck.is_colliding():
				next_anim = "Fall"
			if $LeftSideCheck.is_colliding():
				next_anim = "Fall"
		
		"Hurt":
			$Cooldown.start()
			$SoundFX/Hurt.play()
			next_anim = "Hurt"
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x) #Sign means + or -
			yield(get_tree().create_timer(0.5), "timeout")
			set_state("Dead")
		
		"Dead":
			emit_signal("dead")
			hide()
	
	state = new_state

#Happens multiple times per second

func _physics_process(delta):
	process_gravity(delta)
	
	process_controls() #Checks for inputs
	
	velocity = move_and_slide(velocity, Vector2(0, -1)) #Moves the player
	
	process_collisions()
	
	#Checks to see if the player should be falling down or Idleing
	if state == "Jump":
		if velocity.y > 0:
			set_state("Fall")
	
	if state in ["Jump", "Fall"] and is_on_floor():
#		$SoundFX/Jump.stream = load(textures.SoundFX.Landing)
#		$SoundFX/Jump.play()
		set_state("Idle")
		jump_count = jump_count_max
	
	#If the player's position is over 1,000 you die
	if velocity.y > 1000:
		set_state("Dead")
	
	process_animation()

func process_gravity(delta):
	var gravity_mod = 0
	
	if velocity.y > 0:
		gravity_mod = 500
	
	velocity.y += (gravity + gravity_mod) * delta #Handles gravity

func process_animation():
	if next_anim != $AnimationPlayer.current_animation: #If the new animation does not equal animation
		$AnimationPlayer.play(next_anim) #Play the animation

func process_collisions():
	#Checks if anything is above the player's head
	if $HeadCheck.is_colliding() and $FeetCheck.is_colliding():
		set_state("Crouch")
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Danger":
			hurt()
		if collision.collider.is_in_group("enemies"):
			var player_feet = (position+$Hitbox.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
			else:
				hurt()

func process_controls():
	var right = Input.is_action_pressed("Right")
	var left = Input.is_action_pressed("Left")
	var jump = Input.is_action_just_pressed("Jump")
	var crouch = Input.is_action_pressed("Crouch")
	var sprint = Input.is_action_pressed("Sprint")
	
	var interact = Input.is_action_pressed("Interact")
	
	var climb_up = Input.is_action_pressed("Jump")
	var climb_down = Input.is_action_pressed("Crouch")
	
	var wallslide_right = Input.is_action_pressed("Right") and $RightSideCheck.is_colliding()
	var wallslide_left = Input.is_action_pressed("Left") and $LeftSideCheck.is_colliding()
	#------------------------------
	
	velocity.x = 0
	
	#Run & Sprint Movement
	if right and can_run_right:
		velocity.x = move_speed
		$Sprite.flip_h = false
	
	if left and can_run_left:
		velocity.x = -move_speed
		$Sprite.flip_h = true
	
	if state == "WallSlide":
		if is_on_floor():
			if velocity.x != 0:
				set_state("Run")
	
	if state in ["Crouch"] and not crouch:
		if is_on_floor():
			if velocity.x != 0:
				set_state("Run")
			elif velocity.x == 0:
				set_state("Idle")
		
		elif not is_on_floor():
			if velocity.y < 0:
				set_state("Jump")
			elif velocity.y > 0:
				set_state("Fall")
	
	if can_climb:
		set_state("Climb")
	
	if state == "Climb":
		velocity.y = 0
	
	if state == "Climb":
		if can_climb == false:
			set_state("Idle")
		if climb_down:
			velocity.y += move_speed
		if climb_up and state == "Climb":
			velocity.y -= move_speed
	
	#Handles whether the player is Wallsliding or not
	if wallslide_right or wallslide_left:
		if !is_on_floor() and velocity.y >= 0:
			set_state("WallSlide")
	
	if right and can_run_right:
		if $LeftSideCheck.is_colliding() and !is_on_floor() and state != "Crouch":
			velocity = Vector2(400,-200)
	
	if left and can_run_left:
		if $RightSideCheck.is_colliding() and !is_on_floor() and state != "Crouch":
			velocity = Vector2(-400,-200)
	
	if crouch:
		set_state("Crouch")
	if not crouch:
		if is_on_floor():
			if velocity.x != 0:
				set_state("Run")
	
	if crouch and not state in ["WallSlide", "Climb"]:
		set_state("Crouch")
	
	if is_on_floor():
		if jump and can_jump:
				set_state("Jump")
				$Dust.emitting = true
				velocity.y = jump_speed
				print("Jump! ", velocity.y)
	
	if jump and state in ["Jump", "Fall"] and jump_count < jump_count_max:
		set_state("Jump")
		velocity.y = jump_speed / 1.5
		jump_count -= 1
	
	#State Checks
	if state == "Idle":
		if velocity.x != 0:
			set_state("Run")
	
	if state in ["Run", "Sprint"]:
		if velocity.x == 0:
			set_state("Idle")
		if sprint:
			set_state("Sprint")
		elif not sprint and velocity.x != 0:
			set_state("Run")
	
	if state in ["Idle", "Run"] and !is_on_floor():
		set_state("Jump")

func hurt():
	if state != "Hurt":
		set_state("Hurt")

#func _on_Detection_area_entered(area):
#	if area.is_in_group("climbable"):
#		stats.Actions.Can_Climb = true
#	if area.is_in_group("wallrun"):
#		stats.Actions.Can_WallRun = true

#func _on_Detection_area_exited(area):
#	if area.is_in_group("climbable"):
#		stats.Actions.Can_Climb = false
#		stats.Movement.Gravity = stats.Movement.Gravity_Store
#	if area.is_in_group("wallrun"):
#		stats.Actions.Can_WallRun = false
#		stats.Movement.Jump_Count -= 1
#		change_state(RUN)


