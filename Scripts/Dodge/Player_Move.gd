# Part of godot engine
extends KinematicBody2D

signal give_player_info

# Variable that can be changed
var accel = 6 				# How fast the player accelerates
var decel = 7				# How fast the player decelerates
var max_speed = 365			# Max speed the player can move
var min_speed = 0			# Minimum speed the player can move
var latency = 11			# How many frames of input latency. (effects movenemt and turning)
var min_turn_radius = 0.4	# The minimum turning radius (0 - 0.9. 0 = 180 degrees, 0.9 = crazy small angle)

var standstill_startup_latency = 200

# Misalanous variables
var velocity = 0
var latency_list = []
var movement: Vector2
var time_till_max_speed = (accel * 60.0) / max_speed
var setup_needed = true
var drag_enabled = false
var standstill_startup_frame_counter = 0
var health = 100
var to_cast_on_first_movement = null

func _ready():
	# temp line of code to cast fireball spell VVVVV
	cast_spell("TimeSlice")
	cast_spell("Fireball")
	for i in range(latency):
		latency_list.append(Vector2.ZERO)
	
	#print("time till max speed ", time_till_max_speed, " seconds")

# This function runs every frame
func _physics_process(delta):

	# gets the mouse position, and bases movement off of it
	var new_position = get_global_mouse_position()
	movement = new_position - position;
	
	# Checks if the player is clicking. If so, accelerate, if not decelerate.
	# If the player is clicking, but the object is not moveing, also decelerate
	if drag_enabled and movement != Vector2.ZERO:
		accelerate(accel)
	else:
		decelerate(decel)
	
	# avoids the player moveing around slowly when not clicking
	normalize_low_vel()
	
	# normalizes (sets length to 1) the movement vector and applys the velocity to it
	if movement.length() > (velocity * delta):
		movement = velocity * delta * movement.normalized()
	
	# applys the frame latency variable
	movement = apply_latency(movement)
	
	if to_cast_on_first_movement != null:
		cast_on_first_movement()
	
	# Apply movement
	move_and_collide(movement)


	
# accelerates the player (not past max_speed)
func accelerate(ammount):
	if velocity + ammount <= max_speed:
		velocity += ammount


# decelerates the player (not past min_speed)
func decelerate(ammount):
	if velocity - ammount >= min_speed:
			velocity -= ammount


# returns a boolean of wether the player is turning faster than the min_turning_radius
func is_min_turning_radius():
	var mouse_position = get_global_mouse_position()
	var line_player_mouse = (mouse_position - position).normalized()
	print(line_player_mouse.dot(movement))
	return not line_player_mouse.dot(movement) > min_turn_radius


func apply_min_turning_radius(delta):
	if is_min_turning_radius():
		var angle = atan2(movement.y, movement.x)
		angle += PI/4
		movement.x = cos(angle)
		movement.y = sin(angle)
		movement = velocity * delta * movement.normalized()


func standstill_startup_check():
	if movement == Vector2.ZERO and drag_enabled and standstill_startup_frame_counter == 0:
		standstill_startup_frame_counter = standstill_startup_latency


func standstill_startup():
	if standstill_startup_frame_counter > 0:
		movement = Vector2.ZERO
		standstill_startup_frame_counter -= 1


# avoids the player moveing around slowly when not clicking
func normalize_low_vel():
	if velocity < accel:
		velocity = 0


# applies the frame latency variable to have the player move to where the mouse was, so many frames ago.
func apply_latency(movement):
	latency_list.append(movement)
	if len(latency_list) > latency:
		latency_list.remove(0)
	return latency_list[0]


func cast_spell(type):
	var spell = load("res://Spells/" + type + "/" + type + ".tscn").instance()
	spell.init(self)
	
	if type == "Fireball":
		to_cast_on_first_movement = spell
		spell.position = self.position
	else:
		self.get_parent().call_deferred("add_child", spell)
	

func cast_on_first_movement():
	if movement != Vector2.ZERO:
		self.get_parent().call_deferred("add_child", to_cast_on_first_movement)
		to_cast_on_first_movement = null


# Returns a vector2 of the movement needed to aim from the player to the given position
func aim(aim_to_pos):
	var m = position - aim_to_pos
	m = m.normalized()
	return m


func damaged(ammount):
	health -= ammount
	if health <= 0:
		print("Player has died")


# Gets click input of the mouse and changes the drag_enabled to true or false
# depending on whether the mouse is clicked or not.
func _input(event):
	if event is InputEventMouseButton:
		if drag_enabled:
			drag_enabled = false
		else:			
			drag_enabled = true
