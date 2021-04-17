extends "res://scripts/Attack.gd"

var bashAreaBodies = []
var bashing = false

onready var anim = get_node("../Head/arms/AnimationPlayer")


func attack():
	if can_attack() and not bashing:
		bashing = true
		anim.play("bash")

func attack_target():
	if bashAreaBodies.size() > 0:
		return bashAreaBodies[0]
	return null

func _trigger_attack():
	if bashing:
		bashing = false
		.attack()

func _trigger_attack_done():
	emit_signal("attack_done")


func _on_BashArea_body_entered(body):
	if body.is_in_group("Enemy") and body.has_method("hurt"):
		if bashAreaBodies.find(body) < 0:
			bashAreaBodies.append(body)


func _on_BashArea_body_exited(body):
	var bidx = bashAreaBodies.find(body)
	if bidx >= 0:
		bashAreaBodies.remove(bidx)
