extends Node
const PlayerState = preload("res://Game/PlayerState.gd")

var rng = RandomNumberGenerator.new()
export var sides = []
var enemy

signal player_rolled(damage)

func _ready():
	enemy = get_node("/root/Main/Enemy")
	connect("player_rolled", enemy, "_start_turn")

func roll():
	get_parent().state = PlayerState.ENEMY_TURN
	rng.randomize()
	var result = sides[rng.randi_range(0, sides.size()-1)]
	Events.emit_signal("text_log_push", "You rolled a {result}.".format({"result":result}))
	emit_signal("player_rolled", result)


func _on_Button_pressed():
	if get_parent().state == PlayerState.PLAYER_TURN:
		roll()

func add_sides(sides_to_add):
	sides += sides_to_add
	
func remove_sides(sides_to_remove):
	for side in sides_to_remove:
		sides.erase(side)
