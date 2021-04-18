extends "res://scripts/Attack.gd"

var areaBodies = []
var slashing = false

onready var anim = get_node("../Anubus/AnimationPlayer")


func attack():
	if can_attack() and not slashing:
		slashing = true
		anim.play("Attack")

func attack_target():
	if areaBodies.size() > 0:
		return areaBodies[0]
	return null

func can_attack():
	return .can_attack() and areaBodies.size() > 0

func _trigger_attack():
	if slashing:
		slashing = false
		.attack()

func _trigger_attack_done():
	emit_signal("attack_done")

func _on_SlashArea_body_entered(body):
	if body.has_method("hurt"):
		if areaBodies.find(body) < 0:
			areaBodies.append(body)


func _on_SlashArea_body_exited(body):
	var bidx = areaBodies.find(body)
	if bidx >= 0:
		areaBodies.remove(bidx)
