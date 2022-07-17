extends Node

onready var health_label: Label = $Health
onready var lucky_label: Label = $Lucky
onready var curse_label: Label = $Curse
onready var roll_label: Label = $Roll

func on_health_update(new_health: int, max_health: int):
	health_label.text = "{new}/{max}".format({"new":new_health, "max":max_health})

func on_lucky_update(new_lucky):
	lucky_label.text = str(new_lucky)
	
func on_curse_update(new_curse):
	curse_label.text = str(new_curse)

func on_roll_update(new_roll):
	roll_label.text = str(new_roll)
