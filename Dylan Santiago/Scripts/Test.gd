extends Node2D

var toggled = true

func _ready():
	upgrade_game(1)
	

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

func player_death():
	$Player.global_position = $SpawnPoint.global_position
	$Player.show()

func upgrade_game(id):
	if id == 1:
		$Player.can_run_right = true
		$LevelUpgradeAnim.play("BlackLineGround")
	elif id == 2:
		$Player.can_run_left = true
		$LevelUpgradeAnim.play("AutoTile")
		$Player/Visual/LeftThigh.show()
		$Player/Visual/LeftLeg.show()
	elif id == 3:
		$Player.can_jump = true
		#Music will start here bc i ran out of things to add
		#Spawn enemies
	elif id == 4:
		$Player.can_crouch = true
		$Particles/BackGround1.emitting = true
	elif id == 5:
		$Player.can_sprint = true
		$LevelUpgradeAnim.play("BlanktoGrassTiles")
		$Player/Visual/Body/RightThigh/RightLeg/BootRight.show()
		$Player/Visual/Body/LeftThigh/LeftLeg/BootLeft.show()
	elif id == 6:
		$Player.can_climb = true
		$Player/Visual/Body/RightArm.show()
		$LevelUpgradeAnim.play("Vignette")
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
		$Player.jump_count_max = 2
		$Player/Visual/Body/LeftThigh/LeftLeg/BootLeft/BootWing.show()
		$Player/Visual/Body/RightThigh/RightLeg/BootRight/BootWing.show()
	elif id == 11:
		$Player.slow_fall = true
		#$LevelUpgradeAnim.play("HugeStarReveal")
		$Player/Visual/Body/Head/Scarf.show()


