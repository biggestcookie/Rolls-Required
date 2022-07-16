extends KinematicBody2D


var hurtbox
var rng = RandomNumberGenerator.new()
var cooldown
var player
enum {
	IDLE,
	THROWN,
	PICKUP
}

var state = IDLE

var somethingFuncref = funcref(self, "doSomething")

var sides = {1:somethingFuncref, 2:somethingFuncref, 3:somethingFuncref, 4:somethingFuncref, 5:somethingFuncref, 6:somethingFuncref}

func _ready():
	hurtbox = get_node("Hurtbox")
	player = get_node("/root/World/YSort/Player")
	connect("body_entered", self, '_pickup')

func _throw():
	state = THROWN
	visible = true
	get_node("CollisionShape2D").disabled = false
	return

func onRoll():
	rng.randomize()
	var result = rng.randi_range(1,6)
	sides.get(result).call_func(result)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.

func doSomething(number):
	print('hello {number}'.format({'number': number}))

func _physics_process(delta):
	if player and state == IDLE:
		position = player.position
	if state == THROWN:
		var collide = move_and_collide(Vector2(5,0))
		if collide:
			state = PICKUP
			set_collision_mask_bit(1, true)
			#hurtbox.monitoring = true

func _on_Hurtbox_area_entered(area):
	set_collision_mask_bit(1, false)
	visible = false
	state = IDLE
	
