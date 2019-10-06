extends KinematicBody2D

const UP = Vector2(0, -1) # tells which direction is up

var velocity = Vector2() # velocity vector

var speed = 50 # the speed of opossum
var gravity = 900 # gravity enacted on it
var facing = 1 # the direction its facig

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0 # flip the sprite if velocity.x > 0
	velocity.y += gravity * delta # enforce graitational rules
	velocity.x = facing * speed # velocity.x is = our direction * speed
	velocity = move_and_slide(velocity, UP) # velocity is move_and_slide
	for idx in range(get_slide_count()): # for each possible collision with another body
		var collision = get_slide_collision(idx) # the collision is referenced
		if collision.collider.name == "Player": # if the collision is a player
			collision.collider.hurt() # call the hurt function on the player
		if collision.normal.x != 0: # if the collisions  normal isnt 0
			facing = sign(collision.normal.x) # change directions
			velocity.y = -100 # make it jump a bit
		if position.y > 1000: # if they fall off map
			queue_free() # kill

func take_damage(): # when taking damage
	$AnimationPlayer.play("death") # play death anim
	$CollisionShape2D.disabled = true # disabled colliders
	set_physics_process(false) # stop physics process

func _on_AnimationPlayer_animation_finished(anim_name): # when the animation ends
	if anim_name == "death": # if the animation is a death animation
		queue_free() # kill it
