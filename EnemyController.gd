extends Node

var player
signal end_turn

func _ready():
	player = get_node("/root/Main/Player")
	connect("end_turn", player, "start_turn")
	#display_enemies()

func calculate_enemy_attacks():
	for enemy in get_children():
		enemy.roll()
	emit_signal("end_turn")
	
func display_enemies():
	var enemies = self.get_children()
	var screen_width = get_viewport().get_visible_rect().size.x
	var increment = screen_width/(enemies.size()+1)
	var position = 0
	for enemy in enemies:
		enemy.get_node("EnemyIcon/Node2D").position = Vector2(position + increment, 325)
		enemy.get_node("EnemyIcon/Node2D").visible = true
		position += increment
