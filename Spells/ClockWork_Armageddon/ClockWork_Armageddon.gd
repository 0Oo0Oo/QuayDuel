extends Area2D

var player
var damage = 20
	# var for clock settings
var tick_delay_counter=20               # if rotate(0.1*delta) -> normal clock speed (in radians)
var speed = 0.615                                 # speed in degrees per delta, this is an hour hand config
var tick_delay = 11           #delay for the arm to start moving again

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
		
	else: # rotates arm at increasing speed until it hits the speed limit for the tick
		rotate(deg2rad(speed))
		
func _on_ClockArm_body_entered(body):
	body.damaged(damage)

func _on_12Sec_timeout():
	self.queue_free()
	pass # Replace with function body.


func _on_Second_timeout():
	tick_delay_counter=0
	pass # Replace with function body.
