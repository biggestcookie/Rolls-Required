extends Node
const Enemy = preload("res://Game/Enemy.tscn")

func _ready():
	start_game([Enemy])

func start_game(enemies):
	for enemy in enemies:
			get_node("/root/Main").add_child(enemy.instance())
