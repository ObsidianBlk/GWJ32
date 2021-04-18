extends "res://scripts/FSM/EnemyState.gd"


var points = []
var target = null

func enter():
	connectHealth = true
	.enter()
	var tpos = actor.get_wander_position()
	var dist = actor.global_transform.origin.distance_to(tpos)
	if dist > 1.0:
		points = actor.get_navpath_to(tpos)
	anim.play("Walk")
	if mover:
		mover.walk(true)

func resume():
	.resume()
	anim.play("Walk")

func exit():
	.exit()
	points = []
	target = null

func pause():
	.pause()
	anim.stop()

#func _can_see_player():
#	var player = actor.get_sensor_body("Player")
#	if player and actor.can_see_target(player):
#		return true
#	return false

func handle_update(delta):
	if points.size() <= 0:
		emit_signal("finished", "idle")
		return
	if _can_see_player():
		emit_signal("finished", "chase")
		return
	
	if target == null:
		target = points[0]
	var dist = actor.global_transform.origin.distance_to(target)
	if dist < 1.0:
		points.remove(0)
		if points.size() > 0:
			target = points[0]
		else:
			emit_signal("finished", "idle")
			return
	
	actor.face_position(delta, target)
	if mover:
		#mover.set_motion(-Vector3.FORWARD)
		if actor.can_see_position(target):
			mover.set_motion(-Vector3.FORWARD)
		else:
			mover.set_motion(Vector3.ZERO)
		mover.apply_velocity(delta, true)



