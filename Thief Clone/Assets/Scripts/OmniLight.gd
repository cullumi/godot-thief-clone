extends OmniLight

signal updated_light_level
signal hit_player
signal left_player

onready var floor_ray_cast = $FloorRayCast

var player

var light_level = 0

var is_hitting_player = false

func _ready():
	add_to_group("Detectors")

# warning-ignore:unused_argument
func _process(delta):
	if player != null:
		var player_feet_position = player.get_detection_point().global_transform.origin
		var ray_cast_position = floor_ray_cast.global_transform.origin
		var relative_direction = player_feet_position - ray_cast_position
		floor_ray_cast.cast_to = relative_direction.normalized() * omni_range
		if floor_ray_cast.is_colliding() and floor_ray_cast.get_collider() == player:
			if !is_hitting_player:
				is_hitting_player = true
				emit_signal("hit_player")
			var player_distance = global_transform.origin.distance_to(floor_ray_cast.get_collision_point())
			light_level = (omni_range / player_distance) - 1
			emit_signal("updated_light_level", light_level)
		elif is_hitting_player:
			if !floor_ray_cast.is_colliding() or floor_ray_cast.get_collider() != player:
				is_hitting_player = false
				emit_signal("left_player")

func initialize(player, main):
	self.player = player
	# warning-ignore:return_value_discarded
	connect("hit_player", main, "_on_Light_hit_player")
# warning-ignore:return_value_discarded
	connect("left_player", main, "_on_Light_left_player")
# warning-ignore:return_value_discarded
	connect("updated_light_level", main, "_on_Light_updated_light_level")