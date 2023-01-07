extends Area2D
class_name Player


export(float, 0, 1000) var dash_magnitude := 200
export(float, 0, 1) var dash_weight := 0.5
export(int, 1, 2) var damage := 1
export(float, 0, 50000) var no_dash_radius_squared := 15000

onready var target_position := global_position
onready var arrow := $Arrow as Sprite
onready var dash_cooldown_timer := $Timers/DashCooldown as Timer

#func _unhandled_input(event):
#	if event is InputEventMouse:
#		var direction := (event.global_position - global_position).normalized() as Vector2
#		var direction := (event.global_position - global_position) as Vector2
#		arrow.rotation = direction.angle()
#		if dash_cooldown_timer.is_stopped() and event.button_mask & BUTTON_LEFT:
#			target_position += direction * dash_magnitude
#			dash_cooldown_timer.start()

func _process(delta):
	arrow.rotation = (get_viewport().get_mouse_position() - global_position).angle()

func _physics_process(delta):
	global_position = lerp(global_position, target_position, dash_weight)


func _on_Player_area_entered(area):
	if area is Enemy:
		area.health -= damage
		target_position += Vector2.RIGHT.rotated(arrow.rotation) * dash_magnitude * 1.5
		dash_cooldown_timer.start()


func _on_DashCooldown_timeout():
	if (get_viewport().get_mouse_position() - global_position).length_squared() > no_dash_radius_squared:
		target_position += Vector2.RIGHT.rotated(arrow.rotation) * dash_magnitude
