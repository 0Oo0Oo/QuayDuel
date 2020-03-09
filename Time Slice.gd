extends Node


var player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(player):
	self.player = player
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var timeslice = load("res://Spells/TimeSlice/TimeSlice_Activated.tscn").instance()
	self.add_child(timeslice)