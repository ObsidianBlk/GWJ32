extends "res://objects/player/PlayerState.gd"

func enter():
	.enter()
	anim.stop()

func handle_input(event):
	if event.is_action_pressed("ui_cancel"):
		player.escape_request()
	elif event.is_action_pressed("revive"):
		player.revive()
		emit_signal("finished", "idle")

func handle_update(delta):
	pass

func handle_physics(delta):
	pass

