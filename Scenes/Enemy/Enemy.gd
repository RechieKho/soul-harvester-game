extends Mortal
class_name Enemy


enum State {
	IDLE, WALKING, EATING
}

export(float, 100, 1000) var walk_magnitude = 100
export(float, 100, 1000) var chase_magnitude = 250
export(float, 0, 10) var damage = 2.0
export(float, 0, 5) var deteorating_rate := 2.0 # reduce spawn count per second
export(int, 1, 5) var soul_count := 2

onready var wall_check := $WallCheck as RayCast2D
onready var soul_tree_finder := $SoulTreeFinder as Area2D
onready var soul_tree_eater := $SoulTreeEater as Area2D
onready var animation_player := $AnimationPlayer

var current_state = State.IDLE
var velocity := Vector2.ZERO
var soul_trees := []


func _ready():
	animation_player.play("Idle")

func set_current_state(new_state):
	if current_state == new_state:
		return
	current_state = new_state
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.WALKING:
			wall_check.rotation = rand_range(0, TAU)
			fix_walk_direction()

func _physics_process(delta):
	match current_state:
		State.WALKING:
			fix_walk_direction()
		State.EATING:
			var target_soul_tree = soul_trees[0]
			if not soul_tree_eater.overlaps_area(target_soul_tree):
				# not in range, go to soul tree
				velocity = (target_soul_tree.global_position - global_position).normalized() * chase_magnitude
			else:
				# in range, EAT
				velocity = Vector2.ZERO
				target_soul_tree.health -= damage * delta
				target_soul_tree.spawn_count -= deteorating_rate * delta
	global_position += velocity * delta

func _on_StateChange_timeout():
	if current_state != State.EATING:
		randomize_state()

func fix_walk_direction():
	# update walk direction until it is valid (not walking into wall)
	if wall_check.is_colliding():
		wall_check.rotation = wall_check.get_collision_normal().angle() + rand_range(0, TAU/4)
	velocity = Vector2.RIGHT.rotated(wall_check.rotation) * walk_magnitude

func randomize_state():
	set_current_state(randi() % 2) # only idle and walk


func _on_SoulTreeFinder_area_entered(area):
	soul_trees.append(area)
	set_current_state(State.EATING)


func _on_SoulTreeFinder_area_exited(area):
	soul_trees.pop_at(soul_trees.find(area))
	if len(soul_trees) == 0:
		randomize_state()
