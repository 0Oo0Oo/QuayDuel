#TODO
#Bug: When player sits in the corner of the arena, the fireball sticks in the corner


extends KinematicBody2D
signal collision

var velocity = 800
var damage = 10

var movement = Vector2()
var player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement = velocity * 1/60 * self.player.movement.normalized()
	emit_signal("collision", movement.angle() + deg2rad(180))
	
func init(player):
	self.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(movement)
	
	if collision != null:
		emit_signal("collision", movement.angle())
		movement = player.position - position
		movement = velocity * delta * self.movement.normalized()

# this function is called when the spell collides with the player
func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(damage)