extends Node2D


signal on_released(direction, strength)
signal on_aiming(direction, strength)

const AIM_BUTTON := BUTTON_LEFT

export var is_active := true
export(float, 0, 10000) var radius := 76

onready var cursor := $Cursor as Sprite

var aiming := false
var starting_point := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index != AIM_BUTTON: return
		if event.is_pressed() and not aiming: # start aim
			starting_point = event.global_position
			global_position = event.global_position 
			visible = true
			aiming = true
			get_tree().set_input_as_handled()
		elif not event.is_pressed() and aiming: # stop aim
			var v := (starting_point - event.global_position) as Vector2
			emit_signal("on_released", 
				v.normalized(), min(1, v.length_squared() / (radius * radius)))
			aiming = false
			visible = false
			get_tree().set_input_as_handled()
		return 
	
	if event is InputEventMouseMotion:
		if aiming:
			var v := (starting_point - event.global_position) as Vector2
			var strength := min(1, v.length_squared() / (radius * radius))
			var direction := v.normalized()
			cursor.position = -strength * direction * radius
			emit_signal("on_aiming", direction, strength)
			get_tree().set_input_as_handled()

