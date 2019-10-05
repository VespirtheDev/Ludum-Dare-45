extends "res://levels/LevelTemplate.gd"

var grab_sword = false

func _process(delta):
	if grab_sword == true and Input.is_action_just_pressed("interact"):
		$LevelAnimator.play("sword_obtained")
		$Player.hide()
		grab_sword = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Altar/InteractionButton.show()
		grab_sword = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		grab_sword = false
		$Altar/InteractionButton.hide()

func _on_LevelAnimator_animation_finished(anim_name):
	if anim_name == "sword_obtained":
		GameState.next_level()