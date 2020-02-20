extends Node

# Declare member variables here. Examples:
var runebook = {}
var current_spell = []
signal increment_spell_counter


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_rune("fire")
	self.add_rune("water")
	self.add_rune("air")
	self.add_rune("knowledge")
	self.add_rune("death")
	self.add_rune("life")
	self.add_rune("time")

func add_rune(rune_name) -> void:
	if rune_name in self.runebook.keys():
		self.runebook[rune_name] += 1
	else:
		self.runebook[rune_name] = 1

func _on_RuneCircle_cast():
	if len(self.current_spell) != 0:
		emit_signal("increment_spell_counter")
		print(current_spell)
		self.current_spell = []
