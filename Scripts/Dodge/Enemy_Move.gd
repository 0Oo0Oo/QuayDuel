# Part of godot engine
extends KinematicBody2D

signal enemy_took_damage

# Variable that can be changed
var accel = 15 				# How fast the player accelerates
var decel = 30				# How fast the player decelerates
var max_speed = 700			# Max speed the player can move
var min_speed = 0			# Minimum speed the player can move
var latency = 11			# How many frames of input latency. (effects movenemt and turning)
var min_turn_radius = 0.4	# The minimum turning radius (0 - 0.9. 0 = 180 degrees, 0.9 = crazy small angle)
var twitch_frequency = 10		# how often the AI chooses a new place to move to higher means less twitchy
var standstill_startup_latency = 200
var min_distance_to_walls = 200 	# how close the AI will go to a wall
var stride_length = 400 # how far the fake "clicks" occur from the enemy

# Misalanous variables
var velocity = 0
var latency_list = []
var movement: Vector2
var time_till_max_speed = (accel * 60.0) / max_speed
var standstill_startup_frame_counter = 0
var new_position: Vector2
var rand_x: float
var rand_y: float
var window_width = ProjectSettings.get_setting("display/window/size/width")
var window_height = ProjectSettings.get_setting("display/window/size/height")
var health = 100


func _ready():
	new_position = position
	for i in range(latency):
		latency_list.append(Vector2.ZERO)

# This function runs every frame
func _physics_process(delta):
	
	# gets the random position, and bases movement off of it
	# checks to see if the AI is close to a wall and moves it back towards the center if it is
	if position.x < min_distance_to_walls:
		rand_x = rand_range(self.position.x, self.position.x + stride_length)
	elif position.x > window_width - min_distance_to_walls:
		rand_x = rand_range(self.position.x - stride_length, self.position.x)
	elif int(get_parent().timer) % twitch_frequency == 0: # if its not near a wall will only choose a 
	# new position based on twitch fequency
		rand_x = rand_range(self.position.x - stride_length, self.position.x + stride_length)
	
	# same thing but for y
	if position.y < min_distance_to_walls: 
		rand_y = rand_range(self.position.y, self.position.y + stride_length)
	elif position.y > window_height - min_distance_to_walls:
		rand_y = rand_range(self.position.y - stride_length, self.position.y)
	elif int(get_parent().timer) % twitch_frequency == 0: # if its not near a wall will only choose a 
	# new position based on twitch fequency
		rand_y = rand_range(self.position.y - stride_length, self.position.y + stride_length)

	new_position = Vector2(rand_x, rand_y)
	
	movement = new_position - position;
		
	
	# Checks if the player is clicking. If so, accelerate, if not decelerate.
	# If the player is clicking, but the object is not moveing, also decelerate
	if movement != Vector2.ZERO:
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
	if movement == Vector2.ZERO and standstill_startup_frame_counter == 0:
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
	
# called when the spell hits this object
func damaged(amount):
	emit_signal("enemy_took_damage", amount)
	health -= amount
	if health <= 0:
		print("Bot has died")
