extends RigidBody2D
class_name Player


signal on_soul_count_changed(soul_count)

const FARM_BUTTON := BUTTON_RIGHT

export(float, 0, 1000) var dash_magnitude := 200
export(float, 0, 1) var dash_weight := 0.5
export(int, 1, 2) var damage := 1

onready var arrow := $Arrow as Sprite
onready var dash_cooldown_timer := $Timers/DashCooldown as Timer
onready var farm_cooldown_timer := $Timers/FarmCooldown as Timer
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var hurtbox := $Hurtbox as Area2D

var soul_count : int = 0 setget set_soul_count
var soul_tree_resource := preload("res://Scenes/Tree/SoulTree.tscn") as PackedScene
var just_shooted := false
var just_aimmed := false

func _ready():
	animation_player.play_backwards("Aim")

func set_soul_count(new_count):
	soul_count = max(new_count, 0)
	emit_signal("on_soul_count_changed", soul_count)

func aiming(direction: Vector2, strength: float):
	if not just_aimmed:
		animation_player.play("Aim")
		just_aimmed = true
	arrow.rotation = direction.angle()
	arrow.visible = true

func shoot(direction: Vector2, strength: float):
	if dash_cooldown_timer.is_stopped():
		animation_player.play("Spinning")
		arrow.visible = false
		apply_central_impulse(direction * strength * dash_magnitude)
		dash_cooldown_timer.start()
		hurtbox.monitoring = false
		hurtbox.monitoring = true
		just_shooted = true
		just_aimmed = false

func _unhandled_input(event):
	if not event is InputEventMouseButton: return
	if event.button_index != FARM_BUTTON: return
	if event.is_pressed() and farm_cooldown_timer.is_stopped(): # farm
		var soul_tree = soul_tree_resource.instance()
		var soul_cost = soul_tree.soul_cost
		if soul_count < soul_cost:
			soul_tree.queue_free()
			return 
		get_tree().current_scene.call_deferred("add_child", soul_tree)
		soul_tree.global_position = event.global_position
		farm_cooldown_timer.start()
		set_soul_count(soul_count - soul_cost)
		get_tree().set_input_as_handled()

func _physics_process(delta):
	if just_shooted:
		if linear_velocity.length_squared() < 200:
			animation_player.play_backwards("Aim")
			just_shooted = false

func _on_Hurtbox_area_entered(area):
	if area is Enemy:
		area.health -= damage
		if area.health == 0:
			set_soul_count(soul_count + area.soul_count)
		apply_central_impulse(linear_velocity.normalized() * dash_magnitude * 0.5)
	elif area is SoulTree:
		if area.growing_timer.is_stopped(): # it stop growing
			area.health -= damage
			apply_central_impulse(linear_velocity.normalized() * dash_magnitude * 0.5)
