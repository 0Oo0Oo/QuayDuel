extends TextureProgress

func _ready():
	get_node("../../../VBoxContainer/RuneCircle").connect("increment", self, "increment")

func increment():
	self.value += 1
	if value == self.max_value:
		print("Max spells reached, stop!")
		# here is where we will switch scenes


