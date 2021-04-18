extends "res://objects/player/PlayerState.gd"


onready var audio_jump = get_node("../../Stream_jump")
onready var audio_steps = get_node("../../Stream_steps")

func enter():
	.enter()
	anim.play("Idle")
	audio_steps.stop()
	if player.get_mover().is_lifting(10):
		audio_jump.play()

func exit():
	.exit()


func handle_input(event):
	.handle_input(event)
	if player.is_attacking():
		emit_signal("finished", "attacking")

func handle_update(delta):
	pass

func handle_physics(delta):
	var mover = player.get_mover()
	mover.apply_velocity(delta)
	
	if mover.is_grounded():
		if mover.is_moving():
			emit_signal("finished", "moving")
			return
		else:
			emit_signal("finished", "idle")
			return

