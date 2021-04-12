extends Node
class_name State


signal finished(next_state)

var paused = false

func enter():
	pass

func resume():
	paused = false

func exit():
	pass

func pause():
	paused = true

func handle_input(event):
	pass

func handle_update(delta):
	pass

func handle_physics(delta):
	pass
