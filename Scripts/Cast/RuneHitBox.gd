extends Sprite


var size = 75
var activated = false
signal release


func _ready():
	self.name = self.texture.resource_path
	self.name = self.name.replace("resassetsrunessquare", "").replace("1png", "")


func _input(event):
	if not activated and event is InputEventScreenDrag:
		
		if (
		self.get_global_mouse_position().x < (self.position.x + size) and
		self.get_global_mouse_position().x > (self.position.x - size) and
		self.get_global_mouse_position().y < (self.position.y + size) and
		self.get_global_mouse_position().y > (self.position.y - size)
		):
			
			var path = self.texture.resource_path
			path = path.replace("1","2")
			self.texture = load(path)
			var runeCircle = self.get_parent()
			runeCircle.current_spell.append(self.name)
			activated = true

	elif event is InputEventScreenTouch:
		emit_signal("release")
		var path = self.texture.resource_path
		if path.ends_with("2.png"):
			
			path = path.replace("2","1")
			self.texture = load(path)
			self.get_parent().current_spell.clear()
			activated = false
			