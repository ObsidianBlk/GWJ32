extends KinematicBody


export (float, 0.0, 1.0) var mouse_sensitivity = 0.5


onready var body = self
onready var head = $Head

onready var mover = $Mover

#onready var sensor_ground = $Sensors/Ground


func _ready():
	mover.set_head(head)


func get_mover():
	return mover

#func is_grounded():
#	return sensor_ground.is_colliding()

func escape_request():
	# TODO: Actually send a signal and let the world/level handle whether to exit program
	#   or display a menu.
	get_tree().quit()


func look(x, y):
	mover.look(mouse_sensitivity * x, mouse_sensitivity * y)
	#body.rotation_degrees.y -= mouse_sensitivity * x
	#head.rotation_degrees.x = clamp(head.rotation_degrees.x - (mouse_sensitivity * y), -90, 90)

