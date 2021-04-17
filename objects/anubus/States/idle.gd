extends "res://scripts/FSM/State.gd"


onready var body = get_node("../..")
onready var anim = get_node("../../Anubus/AnimationPlayer")


var idle_timer = null


func enter():
	if idle_timer == null:
		idle_timer = Timer.new()
		add_child(idle_timer)
		idle_timer.connect("timeout", self, "_on_idle_timeout")
		idle_timer.wait_time = 1.0
		idle_timer.start()
		print("Time Left: ", idle_timer.wait_time)
		print("Paused: ", idle_timer.paused)
		print("Is Stopped: ", idle_timer.is_stopped())
	if anim.is_playing():
		anim.play("Idle")

func handle_update(delta):
	pass
	#print(idle_timer.time_left)

func handle_physics(delta):
	pass


func _on_idle_timeout():
	print("Will Idle Now")
	anim.play("Idle")
	idle_timer.start(1.0)


