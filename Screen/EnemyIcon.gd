extends Node

onready var health_label: Label = $Health
onready var lucky_label: Label = $Lucky
onready var curse_label: Label = $Curse

func on_health_update(new_health: int):
	health_label.text = str(new_health)

func on_lucky_update(new_lucky):
	lucky_label.text = str(new_lucky)
	
func on_curse_update(new_curse):
	curse_label.text = str(new_curse)
