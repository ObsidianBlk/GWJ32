extends "res://scripts/FSM/State.gd"

onready var player = get_node("../..")
onready var anim = get_node("../../Head/arms/AnimationPlayer")
onready var crosshair = get_node("../../Head/Overlay/Crosshair")


func _capture_mouse(enable : bool = true):
	if enable:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		crosshair.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		crosshair.visible = false

func enter():
	.enter()
	_capture_mouse()
	var health = player.get_healthCtl()
	health.connect("dead", self, "_on_dead")

func exit():
	.exit()
	var health = player.get_healthCtl()
	health.disconnect("dead", self, "_on_dead")

func pause():
	.pause()
	_capture_mouse(false)


func resume():
	.resume()
	_capture_mouse()


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
			if event.is_action_pressed("attack"):
				player.attacking(true)
			elif event.is_action_released("attack"):
				player.attacking(false)
			elif event is InputEventKey:
				if event.is_action_pressed("ui_cancel"):
					player.escape_request()
				elif event.is_action_pressed("toggle_console"):
					if player.is_in_group("Player"):
						player.remove_from_group("Player")
					else:
						player.add_to_group("Player")
			elif event is InputEventMouseMotion:
				player.look(-event.relative.x, -event.relative.y)

func _on_dead():
	emit_signal("finished", "dead")

