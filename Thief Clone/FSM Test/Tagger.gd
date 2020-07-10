extends Sprite

export (int) var speed = 30

onready var state_label

signal state_changed

var player
var patrol_path_follow
var state = ""

var can_see_player = false
var has_seen_player = false

func _process(delta):
	
	if state == "Wandering":
		patrol_path_follow.increment_along_path(delta * speed)
		position += position.direction_to(patrol_path_follow.position) * delta * speed
	elif state == "Searching":
		pass
	elif state == "Chasing":
		position += position.direction_to(player.position) * delta * speed
	elif state == "Alert":
		patrol_path_follow.increment_along_path(delta * speed)
		position += position.direction_to(patrol_path_follow.position) * delta * speed

func _on_FSMState_entered(new_state):
	state = new_state
	emit_signal("state_changed", state)

func _on_Detection_Radius_area_entered(area):
	if area == player:
		can_see_player = true
		if !has_seen_player:
			has_seen_player = true

func _on_Detection_Radius_area_exited(area):
	if area == player:
		can_see_player = false
