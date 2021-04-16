extends KinematicBody

export var fov : float = 45.0
export var turn_rate : float = 180.0
export var attack_range : float = 2.0
export var attack_rate : float = 1.0
export var attack_angle : float = 5.0
export var sensor_area_path : NodePath = ""


var sensor_area_node = null
var navmesh_node = null


func _ready():
	sensor_area_node = get_node(sensor_area_path)
	if sensor_area_node and sensor_area_node is Area:
		sensor_area_node.connect("body_enter", self, "_on_body_entered")
		sensor_area_node.connect("body_exit", self, "_on_body_exited")
	else:
		sensor_area_node = null

func init(navmesh : Navigation):
	if navmesh_node == null:
		navmesh_node = navmesh


func los_with_target(target : Spatial):
	var space = get_world().direct_space_state
	if target != null:
		var line_of_sight_obstacle = space.intersect_ray(self.global_position, 
			target.global_position, [self], collision_mask)

		if line_of_sight_obstacle.collider == target:
			return true
	return false


func _on_body_entered(body):
	pass

func _on_body_exited(body):
	pass


