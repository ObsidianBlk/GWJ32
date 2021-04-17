extends KinematicBody

signal actor_ready

export var fov : float = 45.0
export var turn_rate : float = 180.0
export var attack_range : float = 2.0
export var attack_rate : float = 1.0
export var attack_angle : float = 5.0
export var wander_delay : float = 3.0
export var wander_delay_variance : float = 1.0
export var navigation_node_path : NodePath = ""
export var wanderspace_node_path : NodePath = ""
export var sensor_mask : int = 0


var sensor_area_node = null
var navmesh_node = null
var wanderspace_node = null
var sensor_bodies = []

var RNG = RandomNumberGenerator.new()

onready var mover = $Mover
onready var health = $HealthCtrl

func _ready():
	RNG.randomize()
	navmesh_node = get_node(navigation_node_path)
	if not (navmesh_node and navmesh_node is Navigation):
		navmesh_node = null
	
	sensor_area_node = get_node("SensorArea")
	if sensor_area_node and sensor_area_node is Area:
		sensor_area_node.connect("body_entered", self, "_on_body_entered")
		sensor_area_node.connect("body_exited", self, "_on_body_exited")
	else:
		sensor_area_node = null
	
	wanderspace_node = get_node(wanderspace_node_path)
	if not(wanderspace_node and wanderspace_node.has_method("get_random_point")):
		wanderspace_node = null
		
	health.connect("dead", self, "_on_dead")
	add_to_group("Enemy")
	emit_signal("actor_ready")

func get_mover():
	return mover

func get_healthCtl():
	return health

func get_RNG():
	return RNG

# Returns all bodies that have entered the sensor_area_node
# If <group> given, returns only those bodies that belong to the given group.
func get_sensor_bodies(group : String = ""):
	if group == "":
		return sensor_bodies
	var res = []
	for i in range(0, sensor_bodies.size()):
		if sensor_bodies[i].is_in_group(group):
			res.append(sensor_bodies[i])
	return res


# Similar to get_sensor_bodies() but only returns the first body in the array.
func get_sensor_body(group : String = ""):
	if group == "":
		if sensor_bodies.size() > 0:
			return sensor_bodies[0]
	else:
		for i in range(0, sensor_bodies.size()):
			if sensor_bodies[i].is_in_group(group):
				return sensor_bodies[i]
	return null

func get_wander_position():
	if wanderspace_node:
		return wanderspace_node.get_random_point()
	return global_transform.origin


func get_navpath_to(pos : Vector3, optimized : bool = false):
	if navmesh_node:
		return navmesh_node.get_simple_path(global_transform.origin, pos, optimized)
	return []

func face_dir(delta, dir: Vector3):
	var angle_diff = global_transform.basis.z.angle_to(dir)
	var turn_right = sign(global_transform.basis.x.dot(dir))
	var max_turn_angle = deg2rad(turn_rate) * delta
	if abs(angle_diff) < max_turn_angle:
		rotation.y = atan2(dir.x, dir.z)
	else:
		rotation.y += max_turn_angle * turn_right

func face_position(delta : float, pos : Vector3):
	var dir = (pos - global_transform.origin).normalized()
	face_dir(delta, dir)

func can_see_target(target : Spatial):
	return target_within_angle(target, fov) and los_with_target(target)

func can_see_position(pos : Vector3):
	return position_within_angle(pos, fov)

func target_within_angle(target : Spatial, angle : float):
	return position_within_angle(target.global_transform.origin, angle)

func position_within_angle(pos : Vector3, angle : float):
	var forwards = global_transform.basis.z
	var d2t = global_transform.origin.direction_to(pos)
	return rad2deg(forwards.angle_to(d2t)) < angle

func los_with_target(target : Spatial):
	var space = get_world().direct_space_state
	if target != null and sensor_mask > 0:
		var los_obstacle = space.intersect_ray(self.global_transform.origin, 
			target.global_transform.origin, [self], sensor_mask)

		if not los_obstacle.empty():
			if los_obstacle.collider == target:
				return true
	return false

func hurt(amount : float, d : Vector3 = Vector3.ZERO, force : float = 0.0):
	print("ENEMY: That hurt")
	health.hurt(amount, d)
	if d.length_squared() > 0 and force > 0:
		mover.push(d * force)


func heal(amount : float):
	health.heal(amount)


func _on_dead():
	mover.enable(false)


func _store_body(body : Spatial):
	var i = sensor_bodies.find(body)
	if i < 0:
		sensor_bodies.append(body)


func _remove_body(body : Spatial):
	var i = sensor_bodies.find(body)
	if i >= 0:
		sensor_bodies.remove(i)


func _on_body_entered(body):
	if body is Spatial:
		_store_body(body)

func _on_body_exited(body):
	if body is Spatial:
		_remove_body(body)


