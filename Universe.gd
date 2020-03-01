extends Node

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	timer += 1


# this function is called when the spell collides with the player
func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(10)