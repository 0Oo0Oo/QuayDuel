extends Node

var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func _process(delta):
	timer += delta

func _on_Timer_timeout():
	get_tree().change_scene("res://GUI.tscn")
