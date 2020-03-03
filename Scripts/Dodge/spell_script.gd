#TODO
#Bug: When player sits in the corner of the arena, the fireball sticks in the corner


extends KinematicBody2D

signal fireball_collision_with_wall

var velocity = 500
var damage = 10

var movement = Vector2()
var player_position = Vector2()
var player_movement = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("fireball_collision_with_wall")
	movement = velocity * 1/60 * player_movement.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(movement)
	
	if collision != null:
		emit_signal("fireball_collision_with_wall")
		movement = player_position - position
		movement = velocity * delta * movement.normalized()



# this function is called when the spell collides with the player
func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	body.damaged(damage)


func _on_Player2_give_player_info(player_pos, player_move) -> void:
	player_position = player_pos
	player_movement = player_move
