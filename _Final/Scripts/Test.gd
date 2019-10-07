extends Node2D

var toggled = true
var game_started = false

func _input(event):
	if event.is_action_pressed("Start") and !game_started:
		start_game()
		game_started = true

func Toggle():
	if toggled:
		$MovingPlatfrom2.moving == false
		$MovingPlatfrom3.moving == false
		$MovingPlatfrom4.moving == false
		$MovingPlatfrom5.moving == true
		for child in get_children():
			if child.get_name() == "Lever":
				child.flip_h = true
	elif not toggled:
		$MovingPlatfrom2.moving == true
		$MovingPlatfrom3.moving == true
		$MovingPlatfrom4.moving == true
		$MovingPlatfrom5.moving == false
		for child in get_children():
			if child.get_name() == "Lever":
				child.flip_h = false

func start_game():
	$LevelUpgradeAnim.play("Start")
	yield($LevelUpgradeAnim, "animation_finished")
	upgrade_game(1)

func player_death():
	$Player.global_position = $SpawnPoint.global_position
	$Player.show()

func upgrade_game(id):
	if id == 1:
		$Player.can_run_right = true
		$LevelUpgradeAnim.play("BlackLineGround")
		yield(get_tree().create_timer(1), "timeout")
		$Player/Visual/Body/RightThigh.show()
		$Inputs/InputAnim.play("Right")
		yield($Inputs/InputAnim, "animation_finished")
		$Player.set_physics_process(true)
	elif id == 2:
		$Player.can_run_left = true
		$LevelUpgradeAnim.play("AutoTile")
		$Player/Visual/LeftThigh.show()
		$Player/Visual/LeftLeg.show()
		$Inputs/InputAnim.play("LeftMovement")
		yield($Inputs/InputAnim, "animation_finished")
	elif id == 3:
		$Player.set_physics_process(false)
		$Player.can_jump = true
		$Player/AnimationPlayer.play("Jump")
		$Inputs/InputAnim.play("Jump")
		$Player.velocity.y = - 250
		$Player.set_physics_process(true)
		yield($Player/AnimationPlayer, "animation_finished")
		#Music will start here bc I ran out of things to add
		#Spawn enemies
	elif id == 4:
		yield(get_tree().create_timer(0.2), "timeout")
		$Player.set_physics_process(false)
		$Player.can_crouch = true
		$Particles/BackGround1.emitting = true
		$Player/AnimationPlayer.play("Crouch")
		$Inputs/InputAnim.play("Crouch")
		yield($Inputs/InputAnim, "animation_finished")
		$Player.set_physics_process(true)
	elif id == 5:
		yield(get_tree().create_timer(1), "timeout")
		$Player.set_physics_process(false)
		$Player.can_sprint = true
		$LevelUpgradeAnim.play("BlanktoGrassTiles")
		$Player/Visual/Body/RightThigh/RightLeg/BootRight.show()
		$Player/Visual/Body/LeftThigh/LeftLeg/BootLeft.show()
		$Player/AnimationPlayer.play("Sprint")
		$Inputs/InputAnim.play("Sprint")
		yield($Inputs/InputAnim, "animation_finished")
		$Player.set_physics_process(true)
	elif id == 6:
		$Player.set_physics_process(false)
		$Player.can_climb = true
		$Player/Visual/Body/RightArm.show()
		$LevelUpgradeAnim.play("Vignette")
		$Player/AnimationPlayer.play("Climb")
		$Inputs/InputAnim.play("Climb")
		yield($Inputs/InputAnim, "animation_finished")
		$Player.set_physics_process(true)
	elif id == 7:
		$Player.can_interact = true
		$LevelUpgradeAnim.play("ShowDecor")
		$Player/Visual/LeftArm.show()
	elif id == 8:
		$Player.can_crawl = true
		$LevelUpgradeAnim.play("SpaceBackground")
	elif id == 9:
		$Player.can_wall_jump = true
		$Particles/BackGround2.emitting = true
		$Player/Visual/Body/Head/CatFace.show()
	elif id == 10:
		$Player.set_physics_process(false)
		$Player.jump_count_max = 2
		$Player/Visual/Body/LeftThigh/LeftLeg/BootLeft/BootWing.show()
		$Player/Visual/Body/RightThigh/RightLeg/BootRight/BootWing.show()
		$Player/AnimationPlayer.play("Jump")
		$Inputs/InputAnim.play("DoubleJump")
		$Player.velocity.y = - 250
		$Player.set_physics_process(true)
		$Player/AnimationPlayer.play("Jump")
		$Player.velocity.y = - 100
		yield($Player/AnimationPlayer, "animation_finished")
	elif id == 11:
		$Player.slow_fall = true
		#$LevelUpgradeAnim.play("HugeStarReveal")
		$Player/Visual/Body/Head/Scarf.show()


