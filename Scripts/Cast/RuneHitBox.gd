extends Sprite

var rune_path = "res://assets/runes/"
var size = 75
var activated = false
signal release
onready var player = get_node("../../../../Player")

func set_name(name):
	self.name = name

func _input(event):
	if not activated and event is InputEventScreenDrag:
		
		if (
		self.get_global_mouse_position().x < (position.x + size) and
		self.get_global_mouse_position().x > (position.x - size) and
		self.get_global_mouse_position().y < (position.y + size) and
		self.get_global_mouse_position().y > (position.y - size)
		):
			
			self.texture = load(rune_path + name + "_activated.png")
			player.current_spell.append(name) # add rune to current_spell
			activated = true

	elif event is InputEventScreenTouch:
		emit_signal("release")
		var path = texture.resource_path
		if path.ends_with("_activated.png"):
			texture = load(rune_path + name + ".png")
			activated = false
			