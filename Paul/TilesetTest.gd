extends Node2D

func _process(delta):
	if Input.is_action_pressed("test1"):
		$AnimationPlayer.play("grass")
	if Input.is_action_pressed("test2"):
		$AnimationPlayer.play("Background")