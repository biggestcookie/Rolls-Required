extends Node
const PlayerState = preload("res://Game/PlayerState.gd")

var rng = RandomNumberGenerator.new()
export var sides = []
var times_rolled
var rules

signal player_rolled(damage)

func _ready():
	reset()
	rules = get_node("/root/Main/Rules")

func roll(enemy):
	get_parent().selected_die = null
	connect("player_rolled", enemy, "_damage_calc")	
	get_parent().state = PlayerState.ENEMY_TURN
	rng.randomize()
	var result = sides[rng.randi_range(0, sides.size()-1)]
	Events.emit_signal("text_log_push", "You rolled a {result}.".format({"result":result}))
	emit_signal("player_rolled", result)
	times_rolled+=1

func _on_Button_pressed():
	if get_parent().state == PlayerState.PLAYER_TURN:
		if times_rolled < rules.roll_limit:
			#roll()
			get_parent().selected_die = self
		else:
			Events.emit_signal("text_log_push", "You cannot roll this die anymore for this turn")

func add_sides(sides_to_add):
	sides += sides_to_add

func remove_sides(sides_to_remove):
	for side in sides_to_remove:
		sides.erase(side)

func reset():
	times_rolled = 0
