extends Node

var textures = ["young_texture", "adventurer_texture", "adventurer_sword_texture", "old_adventurer_texture", "old_adventurer_sword_texture"]
var current_texture = 0

func _process(delta):
	str(print($SwitchTextures.time_left))
	if Input.is_action_just_pressed("ui_select"):
		GameState.next_level()

func _on_SwitchTextures_timeout():
	current_texture += 1
	if current_texture > textures.size() - 1:
		current_texture = 0
	$AnimationPlayer.play(textures[current_texture])
	$SwitchTextures.stop()
	$SwitchTextures.start()


func _on_AnimationPlayer2_animation_finished(anim_name):
	get_tree().change_scene(GameState.title_screen)
