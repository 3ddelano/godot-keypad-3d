extends KinematicBody

# -- Constants --
const MOVESPEED = 7
const GRAVITY = 20
const JUMP = 10

const MOUSE = {
	"x": 0.12, # horizontal
	"y": 0.12 # vertical
}
const ACCELERATION = {
	"normal": 8,
	"air": 1
}

# -- Variables --
var snap
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var accel = ACCELERATION["normal"]

# -- References --
onready var head = $Head
onready var camera = $Head/Camera

# locks the cursor to game window and hides it
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# handles looking aroung with mouse
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE["x"]))
		head.rotate_x(deg2rad(-event.relative.y * MOUSE["y"]))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

# handles main movements like walk and jump
func _physics_process(delta):
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()

	# remove gravity if on floor
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCELERATION["normal"]
		gravity_vec = Vector3.ZERO
	else:
		# apply gravity when in air
		snap = Vector3.DOWN
		accel = ACCELERATION["air"]
		gravity_vec += Vector3.DOWN * GRAVITY * delta

	# jump when on floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * JUMP

	# move the player
	velocity = velocity.linear_interpolate(direction * MOVESPEED, accel * delta)
	movement = velocity + gravity_vec

	var _value = move_and_slide_with_snap(movement, snap, Vector3.UP)
