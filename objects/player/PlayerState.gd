extends "res://scripts/FSM/State.gd"

onready var player = get_node("../..")


func _motion_pressed_or_released(event, mover, name : String, v : Vector3):
	if event.is_action_pressed(name):
		mover.add_motion_effector(name, v)
		return true
	elif event.is_action_released(name):
		mover.clear_motion_effector(name)
		return true
	return false

func _motion_handled(event, mover, info):
	for i in range(0, info.size()):
		if _motion_pressed_or_released(event, mover, info[i].name, info[i].v):
			return true
	return false

func handle_input(event):
	var mover = player.get_mover()
	
	var motions = [
		{"name": "forward", "v": Vector3.FORWARD},
		{"name": "backward", "v": Vector3.BACK},
		{"name": "strafe_left", "v": Vector3.LEFT},
		{"name": "strafe_right", "v": Vector3.RIGHT},
	]
	
	if not _motion_handled(event, mover, motions):
		if event.is_action_pressed("jump"):
			mover.jump()
		else:
			if event is InputEventKey:
				if event.is_action_pressed("ui_cancel"):
					player.escape_request()
			elif event is InputEventMouseMotion:
				player.look(-event.relative.x, -event.relative.y)


