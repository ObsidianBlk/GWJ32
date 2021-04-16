extends KinematicBody


export (float, 0.0, 1.0) var mouse_sensitivity = 0.5


onready var body = self
onready var head = $Head

onready var mover = $Mover
onready var health = $HealthCtrl

#onready var sensor_ground = $Sensors/Ground


func _ready():
	mover.set_head(head)
	health.connect("dead", self, "_on_dead")


func get_mover():
	return mover

func get_healthCtl():
	return health


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


func hurt(amount : float, d : Vector3 = Vector3.ZERO, force : float = 0.0):
	health.hurt(amount, d)
	if d.length_squared() > 0 and force > 0:
		mover.push(d * force)


func heal(amount : float):
	health.heal(amount)

func _on_dead():
	mover.enabled(false)


