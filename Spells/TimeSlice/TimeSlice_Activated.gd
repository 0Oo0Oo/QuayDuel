extends Area2D

# Declare member variables here. Examples:
# var a = 2
var player
var damage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = get_parent().player
	for child in self.get_children():
		child.rotate(self.player.position.angle_to(Vector2(1080/2, 1920/2)))

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(damage)

func _on_Timer_timeout():
	queue_free()
