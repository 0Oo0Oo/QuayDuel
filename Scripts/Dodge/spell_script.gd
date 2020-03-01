extends KinematicBody2D

var velocity = 500
var damage = 10

var movement = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement = self.get_parent().get_parent().get_child(0).position - position
	movement = 5 * movement.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(movement)
	
	if collision != null:
		movement = self.get_parent().get_parent().get_child(0).position - position
		
		movement = velocity * delta * movement.normalized()


# this function is called when the spell collides with the player
func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(10)