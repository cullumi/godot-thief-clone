extends MeshInstance

signal hit_player
signal left_player

var player

func _ready():
	add_to_group("Detectors")

func _on_Area_body_entered(body):
	print (body)
	if body == player:
		emit_signal("hit_player")

func _on_Area_body_exited(body):
	if body == player:
		emit_signal("left_player")

func initialize(player, main):
	self.player = player
# warning-ignore:return_value_discarded
	connect("hit_player", main, "_on_SoundDampener_hit_player")
# warning-ignore:return_value_discarded
	connect("left_player", main, "_on_SoundDampener_left_player")