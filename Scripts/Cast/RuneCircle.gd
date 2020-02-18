extends Node

var current_spell = []
signal increment

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_ready():
	var pivot = Vector2(1080/2, 1920/2) # center of the screen 
	var player = get_node("../../../Player") # "../" means up a dir
	var rotation = 360.0/len(player.runebook)
	var currRot = 90
	var circle_size = 300
	for rune in player.runebook:
		var rotation2D = Vector2(circle_size,circle_size).rotated(deg2rad(currRot))
		var icon = Sprite.new()
		icon.name = rune
		icon.texture = load("res://assets/runes/square/" + str(rune) + "1.png")
		#var hitbox = CollisionShape2D.new()
		icon.set_script(load("res://Scripts/Cast/RuneHitBox.gd"))
		#icon.add_child(hitbox)
		#hitbox.scale = Vector2(100,100)
		#hitbox.global_position = pivot + rotation2D
		icon.global_position = pivot + rotation2D
		#icon.add_child(hitbox)
		currRot += rotation
		icon.connect("release", self, "release")
		self.add_child(icon)

func release():
	if len(current_spell) != 0:
		print(current_spell)
		emit_signal("increment")

	
