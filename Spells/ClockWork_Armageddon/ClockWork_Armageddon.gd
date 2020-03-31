extends Node2D

var player
var center_screen = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.init(player)
	var node = load("res://Spells/ClockWork_Armageddon/ClockWork.tscn").instance()
	node.position = center_screen
	add_child(node)
	
func init(player):
	self.player = player
	#Initializes the center_screen vector so the arm spawns in the right spot
	center_screen.x = get_viewport_rect().size.x/2
	center_screen.y = get_viewport_rect().size.y/2
	print(center_screen)
	