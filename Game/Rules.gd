extends Node

var critical = critical_state.ONE

enum critical_state {
	ZERO,
	ONE,
	TWO,
	THREE
}

var roll_limit = roll_limits.ONE

enum roll_limits {
	ZERO,
	ONE,
	TWO,
	THREE
}

func _ready():
	pass # Replace with function body.
	
func upgrade_critical():
	if critical < critical_state[critical_state.size()-1]:
		critical = critical_state[critical+1]
