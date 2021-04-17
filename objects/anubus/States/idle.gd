extends "res://scripts/FSM/State.gd"

const IDLE_DELAY = 1.0
const IDLE_VARIANCE = 0.5

onready var actor = get_node("../..")
onready var anim = get_node("../../Anubus/AnimationPlayer")


var idle_timer = null
var wander_timer = null



func _get_wander_wait():
	var RNG = actor.get_RNG()
	var variance = actor.wander_delay_variance * 0.5
	return actor.wander_delay + RNG.randf_range(-variance, variance)

func _get_idle_wait():
	var RNG = actor.get_RNG()
	var variance = IDLE_VARIANCE * 0.5
	return IDLE_DELAY + RNG.randf_range(-variance, variance)

func _stop_timers():
	idle_timer.stop()
	wander_timer.stop()

func _start_timers(restart : bool = false):
	if idle_timer == null:
		idle_timer = Timer.new()
		add_child(idle_timer)
		idle_timer.connect("timeout", self, "_on_idle_timeout")
		idle_timer.start(_get_idle_wait())
	else:
		if restart:
			idle_timer.start(_get_idle_wait())
		else:
			idle_timer.start()
	
	if wander_timer == null:
		wander_timer = Timer.new()
		add_child(wander_timer)
		wander_timer.connect("timeout", self, "_on_wander_timeout")
		wander_timer.start(_get_wander_wait())
	else:
		wander_timer.start(_get_wander_wait())
		

func enter():
	var health = actor.get_healthCtl()
	health.connect("dead", self, "_on_dead")
	_start_timers(true)
	if anim.is_playing():
		anim.play("Idle")

func exit():
	.exit()
	var health = actor.get_healthCtl()
	health.disconnect("dead", self, "_on_dead")
	_stop_timers()
	

func pause():
	.pause()
	_stop_timers()

func resume():
	.resume()
	_start_timers()


func _can_see_player():
	var player = actor.get_sensor_body("Player")
	return (player != null and actor.can_see_target(player))

func handle_update(delta):
	if _can_see_player():
		emit_signal("finished", "chase")


func _on_idle_timeout():
	anim.play("Idle")
	idle_timer.start(_get_idle_wait())

func _on_wander_timeout():
	emit_signal("finished", "wander")

func _on_dead():
	emit_signal("finished", "dead")

