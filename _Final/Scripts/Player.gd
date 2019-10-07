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
export (float) var wall_jump_speed = 50
var move_speed = 130

export (float) var gravity = 680
var jump_count = 0
export (int) var jump_count_max = 1
var wall_jump_count = 0
export (int) var wall_jump_count_max = 1

export (bool) var can_run_right = true
export (bool) var can_run_left = false
export (bool) var can_sprint = false
export (bool) var can_jump = false
export (bool) var can_crouch = false
export (bool) var can_crawl = false
export (bool) var can_climb = false
export (bool) var slow_fall = false
export (bool) var can_wall_jump = false
export (bool) var can_interact = false

var on_ladder = false
var facing = 1

func _ready():
	set_state("Idle") #Changes state to Idle by default
	set_physics_process(true)

#Handles changing the game state
func set_state(new_state):
	print(new_state)
	match new_state: #Matches the state 
		"Idle":
			next_anim = "Idle"
		
		"Run":
			move_speed = run_speed
			next_anim = "Run"
		
		"Sprint":
			move_speed = sprint_speed
			next_anim = "Sprint"
		
		"Jump":
			play_jump_sfx()
			$BodyCollider.disabled = false
			next_anim = "Jump"
		
		"Fall":
			$BodyCollider.disabled = false
			next_anim = "Fall"
		
		"Climb":
			move_speed = climb_speed
			next_anim = "Climb"
			$BodyCollider.disabled = true
		
		"Crouch":
			next_anim = "Crouch"
		
		"Crawl":
			move_speed = crawl_speed
			next_anim = "Crawl"
		
		"WallSlide":
			next_anim = "WallSlide"
		
		"Hurt":
			next_anim = "Hurt"
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x) #Sign means + or -
			set_state("Dead")
		
		"Dead":
			hide()
			emit_signal("dead")
			velocity.y = 0
	
	state = new_state

func _physics_process(delta):
	process_gravity(delta)
	
	process_controls() #Checks for inputs
	
	velocity = move_and_slide(velocity, Vector2(0, -1)) #Moves the player
	
	process_collisions()
	
	#Checks to see if the player should be falling down or Idleing
	if state == "Jump":
		if velocity.y > 0:
			set_state("Fall")

	#Handles landing
	if state in ["Jump", "Fall"] and is_on_floor():
		set_state("Idle")
		jump_count = jump_count_max

	#If the player's position is over 1,000 you die
	if position.y > 1000:
		set_state("Dead")

	process_animation()

#Handles the gravity
func process_gravity(delta):
	if state == "Climb":
		return
	
	var gravity_mod = 0
	
	if velocity.y > 0:
		if slow_fall:
			gravity_mod = -100
		else:
			gravity_mod = 500
	
	if state == "WallSlide":
		if velocity.y > 0: #--------------------------------------------------
			velocity.y = 0 #--------------------------------------------------
		velocity.y += 500 * delta #Handles gravity
	else:
		velocity.y += (gravity + gravity_mod) * delta #Handles gravity

func process_animation():
	if next_anim != $AnimationPlayer.current_animation: #If the new animation does not equal animation
		$AnimationPlayer.play(next_anim) #Play the animation

func process_collisions():
	#Checks if anything is above the player's head
	if $HeadCheck.is_colliding() and $FeetCheck.is_colliding():
		set_state("Crouch")
	
	for collision in $Hitbox.get_overlapping_areas():
		if collision.is_in_group("Danger"):
			hurt()
		if collision.is_in_group("Enemies"):
			var player_feet = (position+$Hitbox.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.hurt()
				velocity.y = -200
			else:
				hurt()
	
	if state == "WallSlide":
		if is_on_floor():
			set_state("Idle")
	
	if is_on_floor():
		jump_count = jump_count_max
		wall_jump_count = wall_jump_count_max

func process_controls():
	#Variable input shortcuts built in with full conditions
	var right = Input.is_action_pressed("Right") and can_run_right
	var left = Input.is_action_pressed("Left") and can_run_left
	var jump = Input.is_action_just_pressed("Jump") and can_jump()
	var wall_jump = Input.is_action_just_pressed("Jump") and can_wall_jump()
	var crouch = Input.is_action_pressed("Crouch")
	var sprint = Input.is_action_pressed("Sprint") and can_sprint
	
	var interact = Input.is_action_pressed("Interact")
	
	var climb_up = Input.is_action_pressed("Up") and can_climb()
	var climb_down = Input.is_action_pressed("Down") and can_climb()
	
	var wallslide_right = Input.is_action_pressed("Right") and $RightSideCheck.is_colliding() and not is_on_floor() and can_wall_jump
	var wallslide_left = Input.is_action_pressed("Left") and $LeftSideCheck.is_colliding() and not is_on_floor() and can_wall_jump
	#------------------------------
	
	if state == "Climb":
		velocity.y = 0
	velocity.x = 0
	
	if wallslide_right or wallslide_left:
		set_state("WallSlide")
		
	#Wallslide Movement
	if state == "WallSlide":
		if facing == -1 and right and wall_jump_count > 0:
			set_state("Jump")
			velocity.x = move_speed
			velocity.y = wall_jump_speed
			wall_jump_count -= 1
			return
		
		if facing == 1 and left and wall_jump_count > 0:
			set_state("Jump")
			velocity.x = -move_speed
			velocity.y = wall_jump_speed
			wall_jump_count -= 1 
			return
	
	if state == "WallSlide":
		if not $RightSideCheck.is_colliding() and not $LeftSideCheck.is_colliding():
			set_state("Fall")
			
	if state == "Idle":
		$PlayerSFX/Walk.stop()
		
	#Run & Sprint Movement
	if right:
		velocity.x = move_speed
		$Visual.scale.x = -0.3
		facing = 1
		if $PlayerSFX/Walk.playing != true:
			$PlayerSFX/Walk.playing = true
	
	if left:
		velocity.x = -move_speed
		$Visual.scale.x = 0.3
		facing = -1
		if $PlayerSFX/Walk.playing != true:
			$PlayerSFX/Walk.playing = true
	
	if not $RightSideCheck.is_colliding() and not $LeftSideCheck.is_colliding():
		if not is_on_floor():
			if velocity.y > 100:
				set_state("Fall")
		else:
			set_state("Idle")
	
	if crouch and not state in ["Crouch", "Crawl"] and can_crouch():
		set_state("Crouch")
	if not crouch and state == "Crouch":
		set_state("Idle")
	
	if state == "Crouch": #If the player is in state Crouch
		if velocity.x != 0 and not can_crawl: #If they have velocity in X and can't crawl
			velocity.x = 0 #Set their velocity X to 0
	
	#Climb Movement
	if climb_up or climb_down: #If the player climbs up or down
		set_state("Climb") #Set their state to climbing
	
	#Climbing Collision Checks
	if state == "Climb": #If the player is in the Climb state
		#If the FeetCheck raycast is colliding with solid ground
		if $FeetCheck.is_colliding() and not $FeetCheck.get_collider().is_in_group("DropDown"):
			$BodyCollider.disabled = false #Enable the the collision shape
		elif not $FeetCheck.is_colliding(): #Otherwise if FeetCheck is not colliding
			$BodyCollider.disabled = true #Enable the collision shape
		
		if $RightSideCheck.is_colliding():
			if $RightSideCheck.get_collider().is_in_group("DropDown"):
				$BodyCollider.disabled = true
			elif not $RightSideCheck.get_collider().is_in_group("DropDown"):
				$BodyCollider.disabled = false
		
		if $LeftSideCheck.is_colliding():
			if $LeftSideCheck.get_collider().is_in_group("DropDown"):
				$BodyCollider.disabled = true
			elif not $LeftSideCheck.get_collider().is_in_group("DropDown"):
				$BodyCollider.disabled = false
	
		if climb_down:
			velocity.y += move_speed
		if climb_up and state == "Climb":
			velocity.y -= move_speed
		
		if not can_climb():
			set_state("Fall")
	
	#If the player is jumping in the state Jump or Fall
	if jump and state in ["Jump", "Fall"]:
		set_state("Jump") #Set state to Jump
		velocity.y = jump_speed * 0.85 #Set Y Velocity
		jump_count -= 1 #Decrease jump count by 1
	
	#If the player jumps and is not in state Jump or Fall
	if jump and not state in ["Jump", "Fall"]:
		print("JUMP DAMMIT")
		set_state("Jump") #Set the state to Jump
		$Dust.emitting = true #Dust particles emits
		velocity.y = jump_speed #Set velocity Y to jump speed
		jump_count -= 1 #Decrease Jump count

	#STATE CHECKS
	if state == "Idle":
		if velocity.x != 0:
			set_state("Run")
	
	if state in ["Run", "Sprint"]:
		if velocity.x == 0:
			set_state("Idle")
		if sprint:
			set_state("Sprint")
		elif not sprint and velocity.x != 0 and state != "Jump":
			set_state("Run")
	
	if state == "Crouch":
		if velocity.x != 0:
			set_state("Crawl")
	
	if state == "Crawl":
		if velocity.x == 0:
			set_state("Crouch")
	
	if state in ["Idle", "Run"] and !is_on_floor():
		set_state("Jump")

func hurt():
	if state != "Hurt":
		set_state("Hurt")

func can_jump():
	if can_jump:
		if state != "WallSlide":
			if jump_count > 0:
				return true
	
	return false

func can_wall_jump():
	if can_wall_jump:
		if wall_jump_count > 0:
			return true
	
	return false

func can_crouch():
	if can_crouch:
		if is_on_floor():
			return true
	
	return false

func can_climb():
	if can_climb:
		var collisions = $ClimbDetection.get_overlapping_areas()
		
		if collisions.size() > 0:
			return true
	
	return false

func play_jump_sfx():
	$PlayerSFX/Jump.play()