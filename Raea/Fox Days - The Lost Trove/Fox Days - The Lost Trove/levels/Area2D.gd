extends Area2D

func _on_Area2D_area_entered(area):
	print("Some ara")
	if area.is_in_group("player_attack"):
		print("GOT EM!")
