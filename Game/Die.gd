extends Node
const PlayerState = preload("res://Game/PlayerState.gd")

var rng = RandomNumberGenerator.new()
export var sides = []
var times_rolled
var rules
onready var sides_label = $Node2D/Sides
onready var sprite: Sprite = $Node2D/Sprite
onready var area2d: Area2D = $Node2D/Area2D
onready var player: Player = get_parent()

signal player_rolled(damage)

func _ready():
	reset()
	on_sides_update()
	rules = get_node("/root/Main/Rules")
	area2d.connect("mouse_entered", self, "on_hover_entered")
	area2d.connect("mouse_exited", self, "on_hover_exited")

func roll(enemy):
	player.selected_die = null
	connect("player_rolled", enemy, "_damage_calc")
	player.state = PlayerState.ENEMY_TURN
	rng.randomize()
	var result = sides[rng.randi_range(0, sides.size()-1)]
	Events.emit_signal("text_log_push", "You rolled a {result}.".format({"result":result}))
	emit_signal("player_rolled", result)
	disconnect("player_rolled", enemy, "_damage_calc")
	times_rolled+=1
	if times_rolled >= rules.roll_limit:
		sprite.modulate = Color("#444444")

func add_sides(sides_to_add):
	sides += sides_to_add

func remove_sides(sides_to_remove):
	for side in sides_to_remove:
		sides.erase(side)

func reset():
	times_rolled = 0
	sprite.modulate = Color("#ffffff")

func on_hover_entered():
	if player.selected_die != self:
		sprite.modulate = Color("#A7F0FF")

func on_hover_exited():
	if player.selected_die != self:
		sprite.modulate = Color("#ffffff")
	
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.state == PlayerState.PLAYER_TURN:
			if times_rolled < rules.roll_limit:
				if player.selected_die:
					player.selected_die.sprite.modulate = Color("#ffffff")
				player.selected_die = self
				sprite.modulate = Color("#ffb900")
			else:
				Events.emit_signal("text_log_push", "You cannot roll this die anymore for this turn.")

			
func on_sides_update():
	sides_label.text = str(sides)
