extends Area2D

signal upgrade_player

#ID Guide
#1 - Right Movement | White BG
#2 - Left Movement | Black Line for Ground
#3 - Jump | Blank tiles become grass
#4 - Crouch | Black Lines become tiles autotile
#5 - Running | Partciles in BG
#6 - Arms (Lever + Climb) | Real Space BG
#7 - Crawling | Trees and flowers
#8 - Wall Jump | Enemies
#9 - Double Jump | Parralax
#10 - Slow Fall | Huge Star

export (int) var upgrade_id

func collected(body):
	emit_signal("upgrade_player", upgrade_id)
