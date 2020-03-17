extends Node

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(player):
	self.player = player


func _on_Create_New_Timer_timeout():
	var spike = load("res://Spells/IceSpikes/IceSpike.tscn").instance()
	spike.position = player.position
	self.add_child(spike)


func _on_End_Spell_Timer_timeout():
	self.queue_free()
