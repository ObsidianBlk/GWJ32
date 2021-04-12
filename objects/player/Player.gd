extends KinematicBody


export (float, 0.0, 1.0) var mouse_sensitivity = 0.5
export (float, 0.0) var max_run_velocity = 40.0
#export (float, 0.0) var max_jump_velocity = 100.0
export (float, 0.0) var jump_force = 20
export (float, 0.0) var gravity_accel = 98
export (float, 0.0) var acceleration = 2.0


var up_vector = Vector3.UP
var mxv = Vector2.ZERO
var myv = Vector2.ZERO
var velocity = Vector3.ZERO
var snap = Vector3.ZERO
var drag = 0
var grounded = false
var jumping = false

onready var body = self
onready var head = $Head

onready var sensor_ground = $Sensors/Ground


func _ready():
	drag = acceleration / max_run_velocity

func is_grounded():
	return sensor_ground.is_colliding()

func is_moving():
	return velocity.length() > 0

func escape_request():
	# TODO: Actually send a signal and let the world/level handle whether to exit program
	#   or display a menu.
	get_tree().quit()


func motion(direction : String, enable : bool = true):
	match(direction.to_lower()):
		"f": # W
			myv.x = 0
			if enable:
				myv.x = -1
		"b": # S
			myv.y = 0
			if enable:
				myv.y = 1
		"r": # D
			mxv.y = 0
			if enable:
				mxv.y = 1
		"l": # A
			mxv.x = 0
			if enable:
				mxv.x = -1


func look(x, y):
	body.rotation_degrees.y -= mouse_sensitivity * x
	head.rotation_degrees.x = clamp(head.rotation_degrees.x - (mouse_sensitivity * y), -90, 90)


func jump():
	if is_grounded() and not jumping:
		velocity.y += jump_force
		jumping = true


func _clampVelocitySimple():
	var vg = Vector2(velocity.x, velocity.z)
	if vg.length() > max_run_velocity:
		vg = vg.normalized() * max_run_velocity
		velocity.x = vg.x
		velocity.z = vg.z
	#if abs(velocity.y) > max_jump_velocity:
	#	if velocity.y < 0:
	#		velocity.y = -max_jump_velocity
	#	else:
	#		velocity.y = max_jump_velocity

func apply_velocity(delta):
	var motion = Vector3(mxv.x + mxv.y, 0, myv.x + myv.y).normalized()
	var direction = motion.rotated(up_vector, body.rotation.y)
	
	
	var grav = Vector3.ZERO
	if not is_grounded():
		grav = (up_vector * (-gravity_accel) * delta)
	velocity += (acceleration * direction) - (velocity * Vector3(drag, 0, drag)) + grav
	_clampVelocitySimple()
	velocity = move_and_slide_with_snap(velocity, snap, up_vector, true)

	
	if is_grounded():
		if jumping:
			snap = Vector3.ZERO
		else:
			snap = up_vector.inverse()
	elif jumping:
		jumping = false



