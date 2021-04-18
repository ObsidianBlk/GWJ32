extends "res://scripts/FSM/EnemyState.gd"


var attack_slash = null

func enter():
	connectHealth = true
	.enter()
	
	if attack_slash == null:
		attack_slash = get_node("../../Attack_Slash")
	if mover:
		mover.walk(false)
	anim.play("Run")


func exit():
	.exit()

func _can_attack():
	if attack_slash != null:
		return attack_slash.can_attack()

func handle_update(delta):
	if not _can_see_player():
		emit_signal("finished", "idle")
		return
	var player = actor.get_sensor_body("Player")
	#if not player or not player.is_alive():
	#	emit_signal("finished", "idle")
	#	return
	#if not actor.can_see_target(player):
	#	emit_signal("finished", "idle")
	#	return
	
	var dist = actor.global_transform.origin.distance_to(player.global_transform.origin)
	print("Distance to Player: ", dist)
	if not _can_attack():
		actor.face_position(delta, player.global_transform.origin)
		if mover:
			mover.set_motion(-Vector3.FORWARD)
			mover.apply_velocity(delta)
	else:
		print("Chase -> Attack")
		emit_signal("finished", "attack")


