extends "res://objects/player/PlayerState.gd"


onready var audio = get_node("../../Stream_steps")

func enter():
	.enter()
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	audio.stop()
	anim.play("idle")

func resume():
	paused = false

func exit():
	.exit()

func pause():
	paused = true

func handle_input(event):
	.handle_input(event)
	if player.is_attacking():
		emit_signal("finished", "attacking")

func handle_physics(delta):
	var mover = player.get_mover()
	mover.apply_velocity(delta)
	if mover.is_grounded():
		if mover.is_moving():
			emit_signal("finished", "moving")
			return
	else:
		emit_signal("finished", "inair")
		return
