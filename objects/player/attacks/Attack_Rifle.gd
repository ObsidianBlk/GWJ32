extends "res://scripts/Attack.gd"


export var aim_sensor_path : NodePath = ""

onready var anim = get_node("../Head/arms/AnimationPlayer")

var sensor_mask = 67 # Level, Statics, Enemies
onready var player = get_parent()
onready var aim_sensor_node = get_node(aim_sensor_path)

func init():
	if aim_sensor_node and aim_sensor_node is RayCast:
		aim_sensor_node.cast_to = Vector3(0,0,-attack_range)

func attack():
	if can_attack():
		anim.play("fire")
		.attack()

func attack_target():
	if not (aim_sensor_node and aim_sensor_node is RayCast):
		return null

	var collider = aim_sensor_node.get_collider()
	if collider and collider.has_method("hurt"):
		return collider
	return null
