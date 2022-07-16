extends Node2D

export (int) var index: int = 0

# Test startup code
func _ready():
	# start_interval()
	pass


func start_interval():
	index += 1
	print(index)
	Events.emit_signal("text_log_push", "Hello [wave] world! %s" % index)
	yield(get_tree().create_timer(0.75), "timeout")
	start_interval()
