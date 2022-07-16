extends ScrollContainer


const text_entry_scene: PackedScene = preload("res://Screen/TextLog/TextEntry.tscn")

onready var v_box: VBoxContainer = $VBoxContainer
onready var scrollbar: VScrollBar = get_v_scrollbar()

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("text_log_push", self, "on_text_push")


func on_text_push(new_text: String):
	var entry_instance: RichTextLabel = text_entry_scene.instance()
	entry_instance.bbcode_text = new_text
	v_box.add_child(entry_instance)

	# Scroll to bottom after adding to text log
	yield(get_tree(), "idle_frame")
	scroll_vertical = scrollbar.max_value
