extends Node2D
class_name EnemyUI

onready var sprite: Sprite = $Sprite
onready var name_label: Label = $EnemyName
onready var lucky_label: Label = $Lucky
onready var curse_label: Label = $Curse
onready var health_label: Label = $Position2D/Health
onready var max_health_label: Label = $Position2D/MaxHealth

var enemy_stats: EnemyStats


func _ready():
	sprite.texture = enemy_stats.sprite_tex
	name_label.text = enemy_stats.enemy_name
	max_health_label.text = str(enemy_stats.max_health)
	health_label.text = str(enemy_stats.health)
	lucky_label.text = str(enemy_stats.lucky)
	curse_label.text = str(enemy_stats.curse)


func on_hover():
	# emit index
	pass


func on_health_update(new_health: int):
	health_label.text = str(new_health)


func on_lucky_update(new_lucky):
	lucky_label.text = str(new_lucky)


func on_curse_update(new_curse):
	curse_label.text = str(new_curse)
