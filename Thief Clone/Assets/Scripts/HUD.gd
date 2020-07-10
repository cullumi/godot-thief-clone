extends Control

export (Color) var light_meter_color_0 = Color.black
export (Color) var light_meter_color_1 = Color.white

export (Color) var detection_color_0 = Color.black
export (Color) var detection_color_1 = Color.yellow
export (Color) var detection_color_2 = Color.red

# warning-ignore:unused_class_variable
onready var light_level_meter = $"Panel/Light Level Meter"
onready var detection_indicator = $"Panel/Detection Indicator"

func set_detection_level(level):
	if level == 0:
		detection_indicator.color = detection_color_0
	elif level == 1:
		detection_indicator.color = detection_color_1
	elif level == 2:
		detection_indicator.color = detection_color_2

func set_light_level(level):
	light_level_meter.color = lerp(light_meter_color_0, light_meter_color_1, level)