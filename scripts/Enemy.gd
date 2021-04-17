extends KinematicBody

export var fov : float = 45.0
export var turn_rate : float = 180.0
export var attack_range : float = 2.0
export var attack_rate : float = 1.0
export var attack_angle : float = 5.0
export var navigation_node_path : NodePath = ""


var sensor_area_node = null
var navmesh_node = null
var sensor_bodies = []


func _ready():
	navmesh_node = get_node(navigation_node_path)
	if not (navmesh_node and navmesh_node is Navigation):
		navmesh_node = null
	
	sensor_area_node = get_node("SensorArea")
	if sensor_area_node and sensor_area_node is Area:
		sensor_area_node.connect("body_enter", self, "_on_body_entered")
		sensor_area_node.connect("body_exit", self, "_on_body_exited")
	else:
		sensor_area_node = null


func get_sensor_bodies():
	return sensor_bodies

func face_dir(delta, dir: Vector3):
	var angle_diff = global_transform.basis.z.angle_to(dir)
	var turn_right = sign(global_transform.basis.x.dot(dir))
	var max_turn_angle = deg2rad(turn_rate) * delta
	if abs(angle_diff) < max_turn_angle:
		rotation.y = atan2(dir.x, dir.z)
	else:
		rotation.y += max_turn_angle * turn_right

func can_see_target(target : Spatial):
	return target_within_angle(target, fov) and los_with_target(target)

func target_within_angle(target : Spatial, angle : float):
	var forwards = global_transform.basis.z
	var d2t = global_transform.origin.direction_to(target.global_transform.origin)
	return rad2deg(forwards.angle_to(d2t)) < angle


func los_with_target(target : Spatial):
	var space = get_world().direct_space_state
	if target != null:
		var line_of_sight_obstacle = space.intersect_ray(self.global_position, 
			target.global_position, [self], collision_mask)

		if line_of_sight_obstacle.collider == target:
			return true
	return false


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


