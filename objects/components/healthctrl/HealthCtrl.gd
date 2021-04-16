extends Node


signal hurt
signal dead
signal healed
signal full_health
signal extra_health
signal health_changed(old_health, new_health)


export (float) var max_normal_health = 100 setget _set_max_normal_health
export (float) var max_extra_health = 200 setget _set_max_extra_health
#export (float) var gib_health = -10

var ready = false
var health = 0


func _set_max_normal_health(v : float):
	max_normal_health = max(1, min(v, max_extra_health))

func _set_max_extra_health(v : float):
	max_extra_health = max(1, v)
	if max_extra_health < max_normal_health:
		max_normal_health = max_extra_health


func _ready():
	init()

func init():
	if not ready:
		ready = true
		set_health(max_normal_health)


func set_health(h : float):
	var oh = health
	health = min(h, max_extra_health)
	if health != oh:
		emit_signal("health_changed", oh, health)


func hurt(amount : float):
	# TODO: Spray blood! :)
	var oh = health
	health -= amount
	if oh != health:
		if health <= 0:
			emit_signal("dead")
			# TODO: Check for gibs!
		else:
			emit_signal("hurt")
		emit_signal("health_changed", oh, health)


func heal(amount : float, extra : bool = false):
	var hmax = max_normal_health
	if extra:
		hmax = max_extra_health
	var oh = health
	health = min(health + amount, hmax)
	if oh != health:
		emit_signal("healed")
		if oh < max_normal_health and health >= max_normal_health:
			emit_signal("full_health")
		elif health == max_extra_health:
			emit_signal("extra_health")
		emit_signal("health_changed", oh, health)

