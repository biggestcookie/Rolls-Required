extends Node
class_name EnemyIcon

const PlayerState = preload("res://Game/PlayerState.gd")

onready var health_label: Label = $Health
onready var lucky_label: Label = $Lucky
onready var curse_label: Label = $Curse
onready var roll_label: Label = $Roll
onready var area2d: Area2D = $Area2D
onready var player: Player = $"/root/Main/Player"
onready var sprite: Sprite = $Sprite

signal select(target)

func _ready():
	connect("select", player, "select_enemy")
	area2d.connect("input_event", self, "_on_Area2D_input_event")
	area2d.connect("mouse_entered", self, "on_mouse_entered")
	area2d.connect("mouse_exited", self, "on_mouse_exited")
	
func _exit_tree():
	area2d.disconnect("mouse_entered", self, "on_mouse_entered")
	area2d.disconnect("mouse_exited", self, "on_mouse_exited")

func on_health_update(new_health: int, max_health: int):
	health_label.text = "{new}/{max}".format({"new":new_health, "max":max_health})

func on_lucky_update(new_lucky):
	lucky_label.text = str(new_lucky)
	
func on_curse_update(new_curse):
	curse_label.text = str(new_curse)

func on_roll_update(new_roll):
	roll_label.text = str(new_roll)

func on_mouse_entered():
	if player and player.selected_die and player.state == PlayerState.PLAYER_TURN:
		sprite.modulate = Color("#A7F0FF")

func on_mouse_exited():
	if player and player.selected_die:
		sprite.modulate = Color("#ffffff")

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("select", get_parent())
		sprite.modulate = Color("#ffffff")
