extends Area2D

signal pickup

var textures = {"cherry": "res://assets/sprites/cherry.png",
                "gem": "res://assets/sprites/gem.png"}
var score_value = 0 #Value of the collectable
var health_value = 0 #Value the collectable towards health

func init(type,pos):
	$Sprite.texture = load(textures[type])
	position = pos
	if type == "cherry":
		score_value = 1
		health_value = 1
	if type == "gem":
		score_value = 2

func _on_Collectible_body_entered(body):
	$CollectSound.play()
	hide()



func _on_CollectSound_finished():
	emit_signal("pickup", score_value, health_value)
	queue_free()