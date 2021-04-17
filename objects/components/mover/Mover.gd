extends Node


export var actor_path : NodePath = ""
export var jump_force : float = 20
export var gravity_accel : float = 98
export var max_run_velocity : float = 40.0
export var run_accel :float = 2.0
export var max_walk_velocity : float = 10.0
export var walk_accel : float = 1.0
export (float, 0.1, 10.0, 0.1) var drag_multiplier : float = 1.0


var actor = null
var head = null
var enabled = true

var up_vector = Vector3.UP
var motion = Vector3.ZERO
var velocity = Vector3.ZERO
var snap = Vector3.ZERO
var drag = 0
var walking = false
var grounded = false
var jumping = false

var motion_effectors = []


func _ready():
	actor = get_node(actor_path)
	if not (actor is KinematicBody):
		actor = null
		return
	walk(false)


func set_head(hnode : Spatial):
	if head == null:
		head = hnode

func valid():
	return actor != null

func enable(e : bool = true):
	enabled = e

func is_enabled():
	return enabled

func is_moving():
	return velocity.length() > 0

func is_jumping(threshold : float = 0.0001):
	return velocity.y > threshold


func is_falling(threshold : float = 0.0001):
	return velocity.y < -threshold


func is_grounded(threshold : float = 0.0001):
	return not (is_jumping() or is_falling())

func is_walking():
	return walking

func walk(enable : bool = true):
	walking = enable
	if walking:
		drag = walk_accel / max_walk_velocity
	else:
		drag = run_accel / max_run_velocity
	drag *= drag_multiplier

func jump():
	if is_grounded() and not jumping:
		velocity.y += jump_force
		jumping = true

func look(dx, dy = 0):
	if valid():
		actor.rotation_degrees.y += dx
		if head != null:
			head.rotation_degrees.x = clamp(head.rotation_degrees.x + dy, -90, 90)

func push(v : Vector3):
	velocity += v

func set_motion(mv : Vector3):
	motion = mv

func clear_motion():
	motion = Vector3.ZERO

func add_motion_effector(name : String, mv : Vector3, once : bool = false):
	for i in range(0, motion_effectors.size()):
		if motion_effectors[i].name == name:
			motion_effectors[i].vec = mv
			motion_effectors[i].once = once
			return
	motion_effectors.append({
		"name":name,
		"vec":mv,
		"once":once
	})

func clear_motion_effector(name):
	for i in range(0, motion_effectors.size()):
		if motion_effectors[i].name == name:
			motion_effectors.remove(i)
			break

func clear_motion_effectors():
	motion_effectors.clear()

func _clear_once_effectors():
	for i in range(motion_effectors.size(), 0, -1):
		if motion_effectors[i-1].once:
			motion_effectors.remove(i-1)

func _current_motion_vector():
	var cmotion = motion
	for i in range(0, motion_effectors.size()):
		cmotion += motion_effectors[i].vec
	_clear_once_effectors()
	return cmotion

func _clampVelocitySimple():
	var vg = Vector2(velocity.x, velocity.z)
	if vg.length() > max_run_velocity:
		vg = vg.normalized() * max_run_velocity
		velocity.x = vg.x
		velocity.z = vg.y



func apply_velocity(delta : float):
	if not (valid() and enabled):
		return
	
	var cmotion = _current_motion_vector()
	
	var direction = Vector3.ZERO
	if cmotion.length_squared() > 0:
		direction = cmotion.normalized().rotated(up_vector, actor.rotation.y)
	
	var acceleration = run_accel
	if walking:
		acceleration = walk_accel
	
	var grav = Vector3.ZERO
	if not is_grounded():
		grav = (up_vector * (-gravity_accel) * delta)
	velocity += (acceleration * direction) - (velocity * Vector3(drag, 0, drag)) + grav
	_clampVelocitySimple()
	velocity = actor.move_and_slide_with_snap(velocity, snap, up_vector, true)

	
	if is_grounded():
		if jumping:
			snap = Vector3.ZERO
		else:
			snap = up_vector.inverse()
	elif jumping:
		jumping = false

func face(delta : float, target : Vector3):
	if not (valid() and enabled):
		return
	
	# TODO : Do stuff!
