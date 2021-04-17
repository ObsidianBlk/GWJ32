extends "res://scripts/FSM/State.gd"


onready var actor = get_node("../..")
onready var anim = get_node("../../Anubus/AnimationPlayer")

var mover = null

func enter():
	.enter()
	
	var health = actor.get_healthCtl()
	health.connect("dead", self, "_on_dead")
	
	mover = actor.get_mover()
	if mover:
		mover.walk(false)
	anim.play("Run")


func exit():
	.exit()
	
	var health = actor.get_healthCtl()
	health.disconnect("dead", self, "_on_dead")


func handle_update(delta):
	var player = actor.get_sensor_body("Player")
	if not player:
		emit_signal("finished", "idle")
		return
	if not actor.can_see_target(player):
		emit_signal("finished", "idle")
		return
	
	if actor.global_transform.origin.distance_to(player.global_transform.origin) > 0.5:
		actor.face_position(delta, player.global_transform.origin)
		if mover:
			mover.set_motion(-Vector3.FORWARD)
			mover.apply_velocity(delta)
	else:
		# TODO: Check if "can attack", then call attack state.
		#  This next call is just temporary
		emit_signal("finished", "idle")

func _on_dead():
	emit_signal("finished", "dead")

