extends KinematicBody

# SETTINGS
export (int) var sneak_speed = 2.5
export (int) var walk_speed = 5
export (int) var run_speed = 7.5
export (int) var look_speed = 3

signal update_detection

# COMPOSITION
onready var camera = $Camera
onready var tp_camera = $Camera/Camera2
onready var mesh = $"Standing Character Mesh"
onready var col_shape_up = $"Standing Collision Shape"
onready var col_shape_down = $"Crouched Collision Shape"

# DETECTION
onready var body_point = $"Detection/Body Point"
onready var feet_point = $"Detection/Feet Point"
onready var detect_point = body_point

# POSITIONING
onready var pos_point_body_down = $"Positioning/Crouched Body Point Position"
onready var pos_point_body_up = $"Positioning/Standing Body Point Position"
onready var pos_camera_down = $"Positioning/Crouched Camera Position"
onready var pos_camera_up = $"Positioning/Standing Camera Position"

# MOVEMENT
var move_speed = walk_speed
var is_crouching = false
var is_sneaking = false
var is_walking = false
var is_running = false
# warning-ignore:unused_class_variable
var surface_level = 0

func _ready():
	print(Input.get_connected_joypads())

func _process(delta):
	actions()
	aiming(delta)
	
	if is_walking and Input.is_action_pressed("sprint_sneak"):
		if is_crouching and !is_sneaking:
			is_sneaking = true
			is_running = false
			move_speed = sneak_speed
			emit_signal("update_detection")
		elif !is_crouching and !is_running:
			is_running = true
			is_sneaking = false
			move_speed = run_speed
			emit_signal("update_detection")
	elif (is_running or is_sneaking) and (!is_walking or Input.is_action_just_released("sprint_sneak")):
			is_sneaking = false
			is_running = false
			move_speed = walk_speed
			emit_signal("update_detection")

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(movement(), Vector3.UP)

# BASIC ACTIONS
func actions():
	if Input.is_action_just_pressed("swap_camera_view"):
		if camera.current == true:
			camera.current = false
			tp_camera.current = true
			mesh.visible = true
		else:
			camera.current = true
			tp_camera.current = false
			mesh.visible = false
	
	if Input.is_action_just_pressed("toggle_crouch"):
		if is_crouching:
			camera.translation = pos_camera_up.translation
			body_point.translation = pos_point_body_up.translation
#			detect_point.translation = pos_point_detect_up.translation
			col_shape_down.disabled = true
			col_shape_up.disabled = false
			detect_point = body_point
			is_crouching = false
		else:
			camera.translation = pos_camera_down.translation
			body_point.translation = pos_point_body_down.translation
#			detect_point.translation = pos_point_detect_down.translation
			col_shape_down.disabled = false
			col_shape_up.disabled = true
			detect_point = feet_point
			is_crouching = true

# AIMING
func aiming(delta):
	var velocity = Vector3()
	var direction = Vector3()
	
	if Input.is_action_pressed("look_left"):
		direction.y += 1;
	if Input.is_action_pressed("look_right"):
		direction.y -= 1;
	if Input.is_action_pressed("look_up"):
		direction.x += 1
	if Input.is_action_pressed("look_down"):
		direction.x -= 1;
	velocity = direction.normalized() * look_speed
	
	var look_velocity = velocity * delta
	camera.rotate_x(look_velocity.x)
	rotate_y(look_velocity.y)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -75, 75)

# PHYSICS
func movement():
	var velocity = Vector3()
	var direction = Vector3()
	var forward_direction = rotation_degrees.y
	
	var is_moving = false
	if Input.is_action_pressed("move_left"):
		direction.x += sin(deg2rad(forward_direction - 90))
		direction.z += cos(deg2rad(forward_direction - 90))
		is_moving = true
	if Input.is_action_pressed("move_right"):
		direction.x += sin(deg2rad(forward_direction + 90))
		direction.z += cos(deg2rad(forward_direction + 90))
		is_moving = true
	if Input.is_action_pressed("move_forward"):
		direction.x += sin(deg2rad(forward_direction - 180))
		direction.z += cos(deg2rad(forward_direction - 180))
		is_moving = true
	if Input.is_action_pressed("move_back"):
		direction.x += sin(deg2rad(forward_direction))
		direction.z += cos(deg2rad(forward_direction))
		is_moving = true
	velocity = direction.normalized() * move_speed
	
	if !is_on_floor():
		velocity.y = -move_speed
	else:
		velocity += -get_slide_collision(0).normal * 100
	
	# UPDATES DETECTION WHEN WALKING STARTS OR STOPS
	if is_on_floor() and (is_moving):
		if !is_walking:
			is_walking = true
			emit_signal("update_detection")
	else:
		if is_walking:
			is_walking = false
			emit_signal("update_detection")
	
	return velocity

func get_detection_point():
	return detect_point
