extends Node

onready var sprite: Sprite = $Sprite
onready var enemy_label: Label = $EnemyName
onready var health_label: Label = $Health
onready var max_health_label: Label = $MaxHealth

var temp_sprite_path: String
var temp_name_text: String
var temp_health_text: String
var temp_max_health_text: String


func _init(
	sprite_path: String,
	enemy_name: String,
	health_text: String,
	max_health_text: String
):
	temp_sprite_path = sprite_path
	temp_name_text = enemy_name
	temp_health_text = health_text
	temp_max_health_text = max_health_text


func _ready():
	sprite.texture = load(temp_sprite_path)
	enemy_label.text = temp_name_text
	health_label.text = temp_health_text
	max_health_label.text = temp_max_health_text


func on_health_update(new_health: int):
	health_label.text = str(new_health)
