extends Node

var health = 30
var state
const PlayerState = preload("res://Game/PlayerState.gd")

func _ready():
	state = PlayerState.PLAYER_TURN

func _start_turn(damage):
	health -= damage
	Events.emit_signal("text_log_push", "You take {damage} damage. You have {health} health.".format({"damage":damage, "health":health}))
	state = PlayerState.PLAYER_TURN
	
func get_potential_rolls():
	var dice = self.get_children()
	var potential_rolls = []
	for die in dice:
		for side in die.sides:
			if not potential_rolls.has(side):
				potential_rolls.append(side)
	return potential_rolls
	
func get_all_rolls():
	var dice = self.get_children()
	var all_rolls = []
	for die in dice:
		for side in die.sides:
			all_rolls.append(side)
	return all_rolls
