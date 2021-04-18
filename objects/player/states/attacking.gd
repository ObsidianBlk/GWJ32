extends "res://objects/player/PlayerState.gd"


export (Array, NodePath) var attack_list = []
var cur_attack = 0
var attack_node = null

func enter():
	.enter()
	print("I'm attacking now")
	player.connect("attack_changed", self, "_on_attack_changed")
	cur_attack = player.get_attack_id()
	_on_attack_changed(cur_attack)
	if attack_node == null:
		cur_attack = 0

func exit():
	.exit()
	player.disconnect("attack_changed", self, "_on_attack_changed")


func handle_physics(delta):
	var mover = player.get_mover()
	mover.apply_velocity(delta)
	
	if attack_node != null:
		if player.is_attacking():
			attack_node.attack()
		elif not attack_node.is_one_off():
			print("Stopping attack")
			if mover.is_grounded():
				if mover.is_moving():
					print("Attack -> Move")
					emit_signal("finished", "moving")
					return
				else:
					print("Attack -> idle")
					emit_signal("finished", "idle")
					return
			else:
				emit_signal("finished", "inair")


func _on_attack_changed(id : int):
	if id >= attack_list.size():
		print("WARNING: Attack ID, ", id, ", is out of bounds")
		return
	
	if attack_node != null and id == cur_attack:
		return # Already on that attack!
	
	var new_attack = get_node(attack_list[id])
	if not new_attack:
		print("WARNING: Failed to obtain attack node for ID ", id)
	if attack_node != null:
		if attack_node.is_one_off():
			attack_node.disconnect("attack_done", self, "_on_attack_done")
	attack_node = new_attack
	cur_attack = id
	if attack_node.is_one_off():
		attack_node.connect("attack_done", self, "_on_attack_done")


func _on_attack_done():
	player.attacking(false)
	attack_node.reset()
	var mover = player.get_mover()
	if mover.is_grounded():
		if mover.is_moving():
			emit_signal("finished", "moving")
			return
		else:
			emit_signal("finished", "idle")
			return
	else:
		emit_signal("finished", "inair")
	
	
	
