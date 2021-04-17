extends "res://scripts/FSM/State.gd"


# TODO: Animate dead
# Wait a time
# Remove from scene

onready var anim = get_node("../../Anubus/AnimationPlayer")

func enter():
	.enter()
	anim.stop()
	print("ENEMY: I am now DEAD!")

func handle_update(delta):
	pass


