extends Node2D

func player_death():
	$Player.global_position = $SpawnPoint.global_position

func upgrade_game(id):
	if id == 1:
		$Player.can_run_right = true
		$LevelUpgradeAnim.play("ShowWhiteBackground")
	elif id == 2:
		$Player.can_run_left = true
		$LevelUpgradeAnim.play("BlackLineGround")
		$Player/Visual/LeftThigh.show()
		$Player/Visual/LeftLeg.show()
	elif id == 3:
		$Player.can_jump = true
		$LevelUpgradeAnim.play("Autotile")
		#Spawn enemies
	elif id == 4:
		$Player.can_crouch = true
		$LevelUpgradeAnim.play("BlanktoGrassTiles")
	elif id == 5:
		$Player.can_sprint = true
		$LevelUpgradeAnim.play("ActivateParticles")
		$Player/Visual/Body/RightThight/RightLeg/BootRight.show()
		$Player/Visual/Body/LeftThight/LeftLeg/BootLeft.show()
	elif id == 6:
		$Player.can_climb = true
		$Player.can_interact = true
		$LevelUpgradeAnim.play("SpaceBackground")
		$Player/Visual/Body/RightArm.show()
		$Player/Visual/LeftArm.show()
	elif id == 7:
		$Player.can_crawl = true
		$LevelUpgradeAnim.play("ShowDecor")
	elif id == 8:
		$Player.can_wall_jump = true
		$LevelUpgradeAnim.play("ShowParallax")
		$Player/Visual/Body/Head/CatFace.show()
	elif id == 9:
		$Player.jump_count_max = 2
	elif id == 10:
		$Player.slow_fall = true
		$LevelUpgradeAnim.play("HugeStarReveal")
		$Player/Visual/Body/LeftThight/LeftLeg/BootLeft/BootWing.show()
		$Player/Visual/Body/RightThight/RightLeg/BootRight/BootWing.show()
		$Player/Visual/Body/Head/Scarf.show()


