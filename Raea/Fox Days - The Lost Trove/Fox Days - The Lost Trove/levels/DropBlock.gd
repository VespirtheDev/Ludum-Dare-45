extends KinematicBody2D

var fall = false

func _physics_process(delta):
	if fall:
		move_and_slide(Vector2(0,70))

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		fall = true