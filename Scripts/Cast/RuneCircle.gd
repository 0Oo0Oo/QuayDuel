extends Node

signal cast

var rune_path = "res://assets/runes/runes_100/"
var icon_script_path = "res://Scripts/Cast/RuneHitBox.gd"

func _on_Player_ready():
	var pivot = Vector2(1080/2, 1920/2) # center of the screen 
	var player = get_node("../../../Player") # "../" means up a dir
	var rotation_increment = 360.0/len(player.runebook)
	var currRot = 90
	var circle_size = 300
	for rune in player.runebook:
		var rotation2D = Vector2(circle_size,circle_size).rotated(deg2rad(currRot))
		var icon = Sprite.new()
		icon.name = rune
		icon.texture = load(rune_path + str(rune) + ".png")
		icon.set_script(load(icon_script_path))
		icon.set_name(str(rune))
		icon.global_position = pivot + rotation2D
		currRot += rotation_increment
		icon.connect("release", self, "on_icon_release")
		self.add_child(icon)

func on_icon_release():
	if len(get_node("../../../Player").current_spell) != 0:
		emit_signal("cast")