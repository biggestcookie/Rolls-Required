extends Node

var player
signal end_turn

func _ready():
	player = get_node("/root/Main/Player")
	connect("end_turn", player, "start_turn")

func calculate_enemy_attacks():
	for enemy in get_children():
		enemy.roll()
	emit_signal("end_turn")
	
