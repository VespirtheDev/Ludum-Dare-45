extends Node2D

func _process(delta):
	if Input.is_action_pressed("test1"):
		$AnimationPlayer.play("grass")
	if Input.is_action_pressed("test2"):
		$CanvasLayer/Particles2D.emitting = true
	if Input.is_action_pressed("test3"):
		$CanvasLayer/Particles2D.emitting = false
		$AnimationPlayer.play("Background")