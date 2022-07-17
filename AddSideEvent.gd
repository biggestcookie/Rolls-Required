extends Node

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/Player")

func _on_Button_pressed(select):
	match select:
		"":
			
