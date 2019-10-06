extends Node
var toggle = true
 #connect lever to stop plats

func stop_plats():
	if toggle:
		for child in get_children():
			child.stop()
	else:
		for child in get_children():
			child.start()
