extends "res://objects/player/PlayerState.gd"


func enter():
	pass

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
	
	if not mover.is_grounded():
		emit_signal("finished", "falling")
	elif not mover.is_moving():
		emit_signal("finished", "idle")


