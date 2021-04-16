extends "res://objects/player/PlayerState.gd"


func enter():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func resume():
	paused = false

func exit():
	pass

func pause():
	paused = true

func handle_input(event):
	.handle_input(event)

func handle_update(delta):
	pass

func handle_physics(delta):
	var mover = player.get_mover()
	mover.apply_velocity(delta)
	if mover.is_moving():
		if mover.is_grounded():
			emit_signal("finished", "moving")
		else:
			emit_signal("finished", "falling")
