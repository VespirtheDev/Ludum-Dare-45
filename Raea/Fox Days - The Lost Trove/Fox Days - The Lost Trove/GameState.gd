extends Node

var num_levels = 2
var current_level = 0

var game_scene = 'res://Main.tscn'
var title_screen = 'res://levels/title.tscn'

func restart():
	get_tree().reload_current_scene()

func next_level():
	current_level += 1
	get_tree().change_scene("res://levels/Level0%s.tscn" % current_level)