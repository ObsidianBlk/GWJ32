extends "res://scripts/Attack.gd"


onready var anim = get_node("../Head/arms/AnimationPlayer")

var sensor_mask = 67 # Level, Statics, Enemies


func attack():
	if can_attack():
		anim.play("fire")
		.attack()

func attack_target():
	var space = get_world().direct_space_state
	var target = self.global_transform.origin + (self.global_transform.basis.z * attack_range)
	var obstacle = space.intersect_ray(self.global_transform.origin, target, [self], sensor_mask)

	if not obstacle.empty():
		if obstacle.collider.has_method("hurt"):
			return obstacle.collider
	return null
