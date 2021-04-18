extends "res://objects/player/PlayerState.gd"


onready var audio = get_node("../../Stream_steps")



func enter():
	.enter()
	audio.play()
	anim.play("idle")

func exit():
	.exit()

func handle_input(event):
	.handle_input(event)
	if player.is_attacking():
		emit_signal("finished", "attacking")

func handle_physics(delta):
	var mover = player.get_mover()
	mover.apply_velocity(delta)
	
	if mover.is_grounded():
		if not mover.is_moving():
			emit_signal("finished", "idle")
			return
	else:
		emit_signal("finished", "inair")
		return


