extends Control


onready var congrat := $VBoxContainer/Congrat as Label
onready var replay_hint := $VBoxContainer/ReplayHint as Label

func _ready():
	congrat.text = "Congratulation, you have lived past {0} days! Remember to collect enough soul next time.".format([GameData.days])


func _input(event):
	if event.is_action("ui_accept"):
		get_tree().change_scene("res://Scenes/Battleground/Battleground.tscn")
