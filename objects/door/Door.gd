extends Spatial

export (float, 0.1, 2.0, 0.1) var transition_time = 1.0

var bodies = []
var doors_open = false

onready var tween_dl = $Tween_DL
onready var tween_dr = $Tween_DR
onready var dl = $DoorLeft
onready var dr = $DoorRight

func _open_doors():
	if not doors_open:
		print("Opening door")
		doors_open = true
		
		var from = dl.transform.origin
		var to = Vector3(0.7, 0, 0)
		tween_dl.interpolate_property(dl, "translation", from, to, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
		from = dr.transform.origin
		to = Vector3(-0.7, 0, 0)
		tween_dr.interpolate_property(dr, "translation", from, to, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween_dl.start()
		tween_dr.start()

func _close_doors():
	if doors_open:
		doors_open = false
		
		var from = dl.transform.origin
		var to = Vector3(0, 0, 0)
		tween_dl.interpolate_property(dl, "translation", from, to, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
		from = dr.transform.origin
		tween_dr.interpolate_property(dr, "translation", from, to, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween_dl.start()
		tween_dr.start()

func _on_body_entered(body):
	var bidx = bodies.find(body)
	#print("Body in Group: ", body.is_in_group("Player"))
	#print("Body Name: ", body.name)
	if bidx < 0:
		print("Adding Body")
		bodies.append(body)
		_open_doors()


func _on_body_exited(body):
	var bidx = bodies.find(body)
	if bidx >= 0:
		print("Removing body")
		bodies.remove(bidx)
		if bodies.size() <= 0:
			_close_doors()
