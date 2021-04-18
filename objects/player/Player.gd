extends KinematicBody

signal actor_ready
signal attack_changed(attack_id)

enum ATTACKS {BASH, GUN}


export (float, 0.0, 1.0) var mouse_sensitivity = 0.5

var cur_attack = ATTACKS.GUN
var attack_active = false

onready var body = self
onready var head = $Head

onready var mover = $Mover
onready var health = $HealthCtrl


func _ready():
	#audio.register_sample("steps", "res://assets/audio/sfx/footstep05.ogg")
	#audio.register_sample("jump", "res://assets/audio/sfx/gruntsound.wav")
	
	mover.set_head(head)
	health.connect("dead", self, "_on_dead")
	emit_signal("actor_ready")


func get_mover():
	return mover

func get_healthCtl():
	return health


func attacking(enabled : bool = true):
	attack_active = enabled

func is_attacking():
	return attack_active

func set_attack(id : int):
	var changed = false
	match (id):
		ATTACKS.BASH:
			cur_attack = ATTACKS.BASH
			changed = true
		ATTACKS.GUN:
			cur_attack = ATTACKS.GUN
			changed = true
	if changed:
		emit_signal("attack_changed", cur_attack)

func next_attack():
	cur_attack += 1
	if cur_attack > ATTACKS.GUN:
		cur_attack = ATTACKS.BASH
	emit_signal("attack_changed", cur_attack)

func prev_attack():
	cur_attack -= 1
	if cur_attack < ATTACKS.BASH:
		cur_attack = ATTACKS.GUN
	emit_signal("attack_changed", cur_attack)

func get_attack_id():
	return cur_attack

func is_alive():
	if health != null:
		return health.is_alive()
	return true # Assume alive if health isn't ready.

func escape_request():
	# TODO: Actually send a signal and let the world/level handle whether to exit program
	#   or display a menu.
	get_tree().quit()


func look(x, y):
	mover.look(mouse_sensitivity * x, mouse_sensitivity * y)


func revive():
	health.revive()
	mover.enable(true)
	next_attack()

func hurt(amount : float, d : Vector3 = Vector3.ZERO, force : float = 0.0):
	print("PLAYER: OUCH!")
	health.hurt(amount, d)
	if d.length_squared() > 0 and force > 0:
		mover.push(d * force)


func heal(amount : float):
	health.heal(amount)


func _on_dead():
	mover.enable(false)


