extends Node2D

func _ready():
	$Player.can_run_right = true
	#$LevelUpgradeAnim.play("ShowWhiteBackground")

func player_death():
	$Player.global_position = $SpawnPoint.global_position
	$Player.show()

func upgrade_game(id):
	if id == 1:
		$Player.can_run_left = true
		#$LevelUpgradeAnim.play("BlackLineGround")
	elif id == 2:
		$Player.can_jump = true
		#$LevelUpgradeAnim.play("Autotile")
		#Spawn enemies
	elif id == 3:
		$Player.can_crouch = true
		#$LevelUpgradeAnim.play("BlanktoGrassTiles")
	elif id == 4:
		$Player.can_sprint = true
		#$LevelUpgradeAnim.play("ActivateParticles")
	elif id == 5:
		$Player.can_climb = true
		$Player.can_interact = true
		#$LevelUpgradeAnim.play("SpaceBackground")
	elif id == 6:
		$Player.can_crawl = true
		#$LevelUpgradeAnim.play("ShowDecor")
	elif id == 7:
		$Player.can_wall_jump = true
		#$LevelUpgradeAnim.play("ShowParallax")
	elif id == 8:
		$Player.jump_count_max = 2
	elif id == 9:
		$Player.slow_fall = true
		#$LevelUpgradeAnim.play("HugeStarReveal")


