extends Node

# var event_bus: EventBus 

func _ready():
    # event_bus = $"/root/Main/EventBus"
    EventBus.connect("load_new_screen", self, "on_screen_change")

func on_screen_change(new_screen: Node):
    for child in get_children():
        remove_child(child)
    add_child(new_screen)
