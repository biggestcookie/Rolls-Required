extends KinematicBody2D

export var ACCELERATION: int = 500
export var MAX_SPEED: int = 80
export var ROLL_SPEED: int = 120
export var FRICTION: int = 500

enum PlayerState {
	MOVE,
	ROLL,
	THROW
}

var player_state = PlayerState.MOVE
var velocity: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.DOWN
var stats: Stats

func _ready():
	stats = get_node("Stats")
	stats.connect("no_health", self, "queue_free")


func _physics_process(delta: float):
	match player_state:
		PlayerState.MOVE:
			on_move(delta)
		# PlayerState.ROLL:
		# 	on_roll()
		PlayerState.THROW:
			on_throw()


func move():
	velocity = move_and_slide(velocity)


func on_move(delta: float):
	var input_vector: Vector2 = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	# if Input.is_action_just_pressed("roll"):
	# 	player_state = PlayerState.ROLL
	if Input.is_action_just_pressed("throw"):
		player_state = PlayerState.THROW


# func on_roll():
# 	velocity = roll_vector * ROLL_SPEED
# 	move()


func on_throw():
	velocity = Vector2.ZERO

	attack_animation_finished() # Remove this and move to animation trigger

func attack_animation_finished():
	player_state = PlayerState.MOVE
