extends Area2D

# Declare member variables here. Examples:
# var a = 2
var player
var damage = 30
		
func init(player):
	self.player = player
	var rot = rad2deg(self.player.position.angle_to_point(Vector2(1080/2, 1920/2))) + 90
	print(rot)
	self.rotation_degrees = rot
	self.position = self.player.position

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(damage)

func _on_Timer_timeout():
	queue_free()
