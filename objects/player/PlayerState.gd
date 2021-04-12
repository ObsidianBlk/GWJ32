extends "res://scripts/FSM/State.gd"

onready var player = get_node("../..")



func handle_input(event):
	if event.is_action_pressed("forward"):
		player.motion("f")
	elif event.is_action_released("forward"):
		player.motion("f", false)
	elif event.is_action_pressed("backward"):
		player.motion("b")
	elif event.is_action_released("backward"):
		player.motion("b", false)
	elif event.is_action_pressed("strafe_left"):
		player.motion("l")
	elif event.is_action_released("strafe_left"):
		player.motion("l", false)
	elif event.is_action_pressed("strafe_right"):
		player.motion("r")
	elif event.is_action_released("strafe_right"):
		player.motion("r", false)
	elif event.is_action_pressed("jump"):
		player.jump()
	else:
		if event is InputEventKey:
			if event.is_action_pressed("ui_cancel"):
				player.escape_request()
		elif event is InputEventMouseMotion:
			player.look(event.relative.x, event.relative.y)


