extends Area2D

var player
var damage = 20
var frame_counter = 0
var tick_delay_counter=0 
var normal_clock_constant = 0.1               # if rotate(0.1) -> normal clock speed (in radians)
var speed = 0                                 # speed in frames*radians

# below in unit : frames       # Current configuration is for it moving at x4 speed of regular clock
var frames_per_tick = 3.5 
var speed_increase = 0.5     #multiplier for the speed increase per frame
var tick_delay = 3            #delay for the arm to start moving again

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func init(player):
	self.player = player
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tick_delay > tick_delay_counter :
		rotate(0)
		tick_delay_counter +=1
	else: # rotates arm at increasing speed until it hits the frame limit for the tick
		rotate(normal_clock_constant*speed)
		speed  += normal_clock_constant*speed_increase
		if speed > normal_clock_constant*frames_per_tick: # resets speed once limit is hit
			speed  = 0
			rotate(0)
			tick_delay_counter =0
		
func _on_ClockArm_body_entered(body):
	if (body.get_name() == "Player") or (body.get_name() == "Enemy") : 
		body.damaged(damage)