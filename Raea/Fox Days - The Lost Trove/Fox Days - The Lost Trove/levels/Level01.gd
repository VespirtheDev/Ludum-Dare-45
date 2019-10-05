extends "res://levels/LevelTemplate.gd"

var grab_armor = false

func _ready():
	$Player.stats.Actions.Can_Move = false
	$Player/Camera2D.current = false
	$DadNPC/Camera2D.current = true
	$DadNPC/NPCAnimator.play("run_tutorial")

func _process(delta):
	if grab_armor and Input.is_action_just_pressed("interact") and $Chest/AnimationPlayer.current_animation != "obtain_armor":
		$Chest/AnimationPlayer.play("obtain_armor")

func _on_NPCAnimator_animation_finished(anim_name):
	if anim_name == "run_tutorial":
		$DadNPC/NPCAnimator.play("Idle")
		$Player.stats.Actions.Can_Move = true
		$DadNPC/Camera2D.current = false
		$Player/Camera2D.current = true
	if anim_name == "jump_tutorial":
		$DadNPC/NPCAnimator.play("Idle")
		$Player.stats.Actions.Can_Move = true
		$DadNPC/Camera2D.current = false
		$Player/Camera2D.current = true
	if anim_name == "wallrun_tutorial":
		$DadNPC/NPCAnimator.play("Idle")
		$Player.stats.Actions.Can_Move = true
		$DadNPC/Camera2D.current = false
		$Player/Camera2D.current = true
	if anim_name == "enemy_tutorial":
		$DadNPC/NPCAnimator.play("final_anim")
		$Player.stats.Actions.Can_Move = true
		$DadNPC/Camera2D.current = false
		$Player/Camera2D.current = true

func _on_Event01_body_entered(body):
	if body.is_in_group("player"):
		$Player.stats.Actions.Can_Move = false
		$Player/Camera2D.current = false
		$DadNPC/Camera2D.current = true
		$DadNPC/NPCAnimator.play("jump_tutorial")
		$EventTriggers/Event01.queue_free()

func _on_Event02_body_entered(body):
	if body.is_in_group("player"):
		$Player.stats.Actions.Can_Move = false
		$Player/Camera2D.current = false
		$DadNPC/Camera2D.current = true
		$DadNPC/NPCAnimator.play("wallrun_tutorial")
		$EventTriggers/Event02.queue_free()

func _on_Event03_body_entered(body):
	if body.is_in_group("player"):
		$Player.stats.Actions.Can_Move = false
		$Player/Camera2D.current = false
		$DadNPC/Camera2D.current = true
		$DadNPC/NPCAnimator.play("enemy_tutorial")
		$EventTriggers/Event03.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	GameState.next_level()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		grab_armor = true
		$Chest/Chest2.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		grab_armor = false
		$Chest/Chest2.hide()

func _on_Crouch_Tutorial_body_entered(body):
	if body.is_in_group("player"):
		$CrouchControl.show()

func _on_Crouch_Tutorial_body_exited(body):
	if body.is_in_group("player"):
		$CrouchControl.hide()