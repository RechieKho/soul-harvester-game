extends Area2D
class_name Mortal


signal on_dead()

export(float, 1, 5) var max_health := 4.0

onready var health := max_health setget set_health

func set_health(new_health):
	if new_health < health:
		var original_modulate = modulate
		modulate = Color.black
		get_tree().create_tween().tween_property(self, "modulate", original_modulate, 0.5)
	health = clamp(new_health, 0, max_health)
	if health == 0:
		emit_signal("on_dead")
