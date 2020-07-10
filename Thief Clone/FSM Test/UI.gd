extends Control

onready var tagger_state_label = $"Tagger State"

func set_tagger_state_label(new_state):
	tagger_state_label.text = new_state