extends Node2D


export(float, 1, 5) var soul_demand_multiplier := 1.2
export(int, 0, 100) var initial_soul_demand := 20

onready var soul_meter := $CanvasLayer/SoulMeter
onready var player := $Player

var days := 0
var end_resource := preload("res://Scenes/End/End.tscn") as PackedScene

func _ready():
	soul_meter.soul_demand = (initial_soul_demand)

func next_day():
	if player.soul_count <= soul_meter.soul_demand: 
		GameData.days = days
		get_tree().change_scene_to(end_resource)
		return
	days += 1
	player.soul_count -= soul_meter.soul_demand
	soul_meter.soul_demand *= soul_demand_multiplier


func _on_Duration_timeout():
	next_day()
