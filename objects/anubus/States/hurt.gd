extends "res://scripts/FSM/EnemyState.gd"


func enter():
	connectHealth = true
	.enter()
	anim.stop()
	anim.connect("animation_finished", self, "_on_anim_finished")
	anim.play("Hurt")

func exit():
	.exit()
	anim.disconnect("animation_finished", self, "_on_anim_finished")

func _on_anim_finished(name):
	emit_signal("finished", "idle")


func _on_hurt():
	pass
