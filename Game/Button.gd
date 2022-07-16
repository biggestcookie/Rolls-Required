extends Button

func _ready():
	connect("pressed", get_parent(), "_on_Button_pressed")
