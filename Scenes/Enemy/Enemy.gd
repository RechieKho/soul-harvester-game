extends Area2D
class_name Enemy

signal on_dead()

enum State {
	IDLE, WALKING
}

export(float, 100, 1000) var walk_magnitude = 100
export(int, 1, 5) var max_health := 4

onready var wall_check := $WallCheck as RayCast2D
onready var health := max_health setget set_health

var current_state = State.IDLE
var velocity := Vector2.ZERO

func set_health(new_health):
	health = clamp(new_health, 0, max_health)
	if health == 0:
		emit_signal("on_dead")
		queue_free()

func _physics_process(delta):
	if current_state == State.WALKING:
		fix_walk_direction()
	global_position += velocity * delta

func _on_StateChange_timeout():
	next_state()

func fix_walk_direction():
	# update walk direction until it is valid (not walking into wall)
	if wall_check.is_colliding():
		wall_check.rotation = wall_check.get_collision_normal().angle() + rand_range(0, TAU/4)
	velocity = Vector2.RIGHT.rotated(wall_check.rotation) * walk_magnitude

func next_state():
	current_state = randi() % len(State)
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.WALKING:
			wall_check.rotation = rand_range(0, TAU)
			fix_walk_direction()
