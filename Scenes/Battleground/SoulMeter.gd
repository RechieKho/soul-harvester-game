extends Control


onready var label := $NinePatchRect/Label as Label

var soul_count : int = 0 setget set_soul_count
var soul_demand : int = 0 setget set_soul_demand


func _ready():
	update_label()

func set_soul_count(value):
	soul_count = max(value, 0)
	update_label()

func set_soul_demand(value):
	soul_demand = max(value, 0)
	update_label()

func update_label():
	label.text = "{0}/{1}".format([soul_count, soul_demand])
