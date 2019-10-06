extends Area2D
var is_on = true
signal toggle

func Toggle():
	if is_on == true:
		is_on = false
		emit_signal("toggle", is_on)
	else:
		is_on = true
		emit_signal("toggle", is_on)
	$Sprite.flip_h = is_on

