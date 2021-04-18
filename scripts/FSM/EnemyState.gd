extends "res://scripts/FSM/State.gd"


onready var actor = get_node("../..")
onready var anim = get_node("../../Anubus/AnimationPlayer")

var connectHealth = false
var health = null
var mover = null

func enter():
	.enter()
	mover = actor.get_mover()
	health = actor.get_healthCtl()
	if connectHealth:
		health.connect("dead", self, "_on_dead")
		health.connect("hurt", self, "_on_hurt")

func exit():
	.exit()
	if connectHealth:
		health.disconnect("dead", self, "_on_dead")
		health.disconnect("hurt", self, "_on_hurt")

func _can_see_player():
	var player = actor.get_sensor_body("Player")
	return (player != null and player.is_alive() and actor.can_see_target(player))

func _on_dead():
	emit_signal("finished", "dead")

func _on_hurt():
	emit_signal("finished", "hurt")

