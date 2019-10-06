extends KinematicBody2D

var moving = true
var velocity = Vector2()
var dir = -1
var target = Vector2()
export var speed = 1
export var wait_time = 0 

#the way you can connect the lever is you connect signals to the start and stop funcs

func _process(delta):
	#lets you stop the platfrom
	if moving:
		if dir == -1: #chages directions
			target = $Pos/Start.position# sets target
			if position.floor() > Vector2($Pos/Start.position.x -1,$Pos/Start.position.y - 1): #sets the position to a int and then if the two position matches then the platfrom chages direction
				dir = 1
				wait(wait_time)
		elif dir == 1:  #the other direction same as the first 
			target = $Pos/End.position
			if position.floor() < Vector2($Pos/End.position.x + 1,$Pos/End.position.y + 1):
				dir = -1
				wait(wait_time)
		velocity = (target - position).normalized() * speed
		velocity = move_and_slide(velocity)

#this lets you turn it on or off
func wait(time):
	if time == 0:
		return
	moving = false 
	yield(get_tree().create_timer(time), "timeout")
	moving = true 


func start():
	moving = true

func stop():
	moving = false