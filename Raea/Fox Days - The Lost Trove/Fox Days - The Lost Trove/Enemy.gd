extends KinematicBody2D

signal enemy_killed

export (int) var speed
export (int) var gravity

var velocity = Vector2()
var facing = 1 #movement aong the x axis, 1 is right and -1 is left

func _ready():
	self.connect("enemy_killed", get_tree().get_root().get_node("Level0%s" % GameState.current_level), "_on_Collectible_pickup")
	print("Level%s" % GameState.current_level)

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	
	velocity.y += gravity * delta
	velocity.x = facing * speed
	velocity = move_and_slide(velocity, Vector2(0, -1)) #has the character move in a constant direction
	
	if $GroundCheckLeft.is_colliding():
		pass
	elif not $GroundCheckLeft.is_colliding():
		facing = 1
	if $GroundCheckRight.is_colliding():
		pass
	elif not $GroundCheckRight.is_colliding():
		facing = -1
	
	for idk in range(get_slide_count()):
		var collision = get_slide_collision(idk)
		
		if collision.collider.name == "Player":
			collision.collider.hurt()
			
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100
			
		if position.y > 1000:
			queue_free()

func take_damage():
	$DeathSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		emit_signal("enemy_killed",3,0)
		queue_free()

func _on_HitBox_area_entered(area):
	if area.is_in_group("player_attack"):
		$AnimationPlayer.play("death")
		$Hitbox.disabled = true
		set_physics_process(false)

func _on_DeathSound_finished():
	$AnimationPlayer.play("death")
	$Hitbox.disabled = true
	set_physics_process(false)