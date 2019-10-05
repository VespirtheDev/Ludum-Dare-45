extends Node

#Signals
signal score_changed 

var Collectible = preload("res://levels/Collectible.tscn") #Collectible variable used for instancing

var textures = {"Level_Tilesets": {"day": "res://assets/tilesets/tiles_world.tres", "midday": "res://assets/tilesets/tiles_world_midday.tres", "evening": "res://assets/tilesets/tiles_world_evening.tres", "night": "res://assets/tilesets/tiles_world_night.tres"},
                "Background_Textures": {"Layer_Back": {"day": "res://assets/environment/layers/back.png","midday": "res://assets/environment/layers/back_midday.png","evening": "res://assets/environment/layers/back_evening.png","night": "res://assets/environment/layers/back_night.png"},"Layer_Mid": {"day": "res://assets/environment/layers/middle.png","midday": "res://assets/environment/layers/middle_midday.png","evening": "res://assets/environment/layers/middle_evening.png","night": "res://assets/environment/layers/middle_night.png"},"Layer_Front": {"day": "","midday": "","evening": "","night": ""}}
               }

export (String) var player_texture #Sets the texture for the player
export (String) var tileset_texture #Sets the texture for the tilemap
 
var score

onready var pickups = $Collectables #Sets a variable for the collectable tilemap

func _ready():
	score = 0 #Sets the score level to 0
	emit_signal("score_changed", score) #Initializes the score 
	
	pickups.hide() #Hides the collectable tilemap
	$Player.start($PlayerSpawn.position) #Moves player to the Player Spawn position
	
	texture_update() #Sets initial textures for the level
	set_camera_limits() #Sets the camera's limits
	spawn_pickups() #Spawns the pickups

#Updates the texture for the level
func texture_update():
	$Player.texture_swap(player_texture)
	$World.tile_set = load(textures.Level_Tilesets[tileset_texture])
	$Backdrop.tile_set = load(textures.Level_Tilesets[tileset_texture])
	$ParallaxBackground/Back/Sprite.texture = load(textures.Background_Textures.Layer_Back[tileset_texture])
	$ParallaxBackground/Mid/Sprite.texture = load(textures.Background_Textures.Layer_Mid[tileset_texture])

#Sets camera limits
func set_camera_limits():
	var map_size = $World.get_used_rect() #Finds the amount of space used by the World tilemap
	var cell_size = $World.cell_size #Finds the size of each cell within the World tilemap
	$Player/Camera2D.limit_left = (map_size.position.x -10) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 10) * cell_size.x

#Instances in the Collectable scene
func spawn_pickups():
	for cell in pickups.get_used_cells(): #For each cell used by the Collectable tilemap
		var id = pickups.get_cellv(cell) #Sets id to the tile index
		var type = pickups.tile_set.tile_get_name(id) #Sets the type of collectable by the tile name indicated by the id position
		if type in ["gem", "cherry"]: #If the type of the collectible exists
			var c = Collectible.instance() #Instances in the Collectable
			var pos = pickups.map_to_world(cell) #Sets position to the cell being used
			c.init(type,pos + pickups.cell_size/2) #Calls the init function within the Collectable, sets the type and position
			add_child(c) #Adds the Collectable to the game
			c.connect("pickup", self, "_on_Collectible_pickup") #Connects the Collectable pickup signal to the pickup function

#Handles what happens when you pick up a collectable
func _on_Collectible_pickup(score_value, health_value):
	score += score_value
	$Player.stats.Health.Current_Life += health_value
	emit_signal("score_changed",score)
	$CanvasLayer/HUD._on_Player_life_changed($Player.stats.Health.Current_Life)
	print(str($Player.stats.Health.Current_Life))

func enemy_killed():
	score += 3
	emit_signal("score_changed",score)

#Handles when the player dies
func _on_Player_dead():
	GameState.restart()
