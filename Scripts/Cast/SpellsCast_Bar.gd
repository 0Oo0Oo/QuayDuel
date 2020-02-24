extends TextureProgress

func _on_Player_increment_spell_counter():
	self.value += 1
	if value == self.max_value:
		get_tree().change_scene("res://Universe.tscn")
