extends Control


signal timeout

export(float, 0, 1000) var duration := 100.0 # in seconds
export var active := true

onready var counter := duration
onready var label := $NinePatchRect/Label as Label

func _process(delta):
	if active:
		counter = max(counter - delta, 0)
		label.text = "{0}s".format([round(counter)])
		if counter == 0:
			emit_signal("timeout")
			counter = duration
