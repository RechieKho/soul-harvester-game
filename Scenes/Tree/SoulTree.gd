extends Mortal
class_name SoulTree


export(int, 1, 10) var soul_cost := 1
export(float, 1, 3) var spawn_count := 2.0
export(float, 0, 1000) var spawn_radius := 100.0
export(float, 0, 1) var introvert := 0.5 # the more introvert it is, the less the spawn count when farm in crowded area

onready var growing_timer := $Timer/Growing as Timer
onready var save_margin := $SaveMargin as Area2D
var enemy_resource := preload("res://Scenes/Enemy/Enemy.tscn") as PackedScene
var nearby_tree_count := 0

func _on_Growing_timeout():
	$SmallTree.visible = false
	$BigTree.visible = true

func _on_SoulTree_on_dead():
	if growing_timer.is_stopped():
		spawn_count = max(spawn_count - nearby_tree_count * introvert, 0)
		for i in ceil(spawn_count):
			randomize()
			var enemy := enemy_resource.instance()
			get_tree().current_scene.call_deferred("add_child", enemy)
			enemy.global_position = global_position + Vector2.RIGHT.rotated(rand_range(0, TAU)) * rand_range(0, spawn_radius)
	queue_free()


func _on_SaveMargin_area_entered(area):
	# if there is a tree nearby
	nearby_tree_count += 1

func _on_SaveMargin_area_exited(area):
	# if fewer tree nearby
	nearby_tree_count = max(nearby_tree_count - 1, 0)
