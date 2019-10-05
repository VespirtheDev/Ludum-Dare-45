extends "res://levels/LevelTemplate.gd"

var girl_found = false

func _process(delta):
	if girl_found and Input.is_action_just_pressed("interact"):
		$Girl/AnimationPlayer.play("found_girl")
		girl_found = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		girl_found = true
		$Girl/InteractionButton.show()


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		girl_found = false
		$Girl/InteractionButton.hide()