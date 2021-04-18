extends "res://scripts/FSM/EnemyState.gd"

var attack = null

func enter():
	.enter()
	if attack == null:
		attack = get_node("../../Attack_Slash")
	attack.connect("attack_done", self, "_on_attack_done")

func exit():
	.exit()
	attack.disconnect("attack_done", self, "_on_attack_done")

func handle_update(delta):
	attack.attack()

func _on_attack_done():
	print("Enemy: Done with attack")
	attack.reset()
	emit_signal("finished", "chase")

