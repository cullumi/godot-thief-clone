extends Node

onready var ui = $UI
onready var player = $Player
onready var tagger = $Tagger
onready var tagger_patrol_path_follow = $"Patrol Path/PathFollow2D"

func _ready():
	tagger.player = player
	tagger.patrol_path_follow = tagger_patrol_path_follow

func _on_Tagger_state_changed(new_state):
	if ui == null:
		ui = $UI
	ui.set_tagger_state_label(new_state)
