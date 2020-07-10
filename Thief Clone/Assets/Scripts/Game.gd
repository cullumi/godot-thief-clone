extends Node

onready var hud = $HUD
onready var player = $"Player"

var detection_level = 0
var light_level = 0

var lights_hitting_player = 0
var carpets_hitting_player = 0

func _ready():
	get_tree().call_group("Detectors", "initialize", player, self)
	update_detection()

# warning-ignore:unused_argument
func _process(delta):
	light_level = 0

func update_detection():
	
	detection_level = 0
	
	if player.is_running:
		detection_level += 2
	elif player.is_sneaking:
		detection_level += 0
	elif player.is_walking:
		detection_level += 1
	
	if carpets_hitting_player > 0 and (player.is_walking or player.is_running):
		detection_level -= 1
	
	if lights_hitting_player <= 0:
		hud.set_light_level(0)
	
	if light_level > 0.15:
		detection_level += 1
		if light_level >= .5:
			detection_level += 1
	
	hud.set_detection_level(clamp(detection_level, 0, 2))

func _on_Light_hit_player():
	lights_hitting_player += 1
	update_detection()

func _on_Light_left_player():
	lights_hitting_player -= 1
	update_detection()

func _on_Player_update_detection():
	update_detection()

func _on_SoundDampener_hit_player():
	carpets_hitting_player += 1
	update_detection()

func _on_SoundDampener_left_player():
	carpets_hitting_player -= 1
	update_detection()

func _on_Light_updated_light_level(level):
	self.light_level += level
	hud.set_light_level(clamp(self.light_level, 0, 1))
	update_detection()
