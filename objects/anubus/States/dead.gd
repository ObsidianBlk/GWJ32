extends "res://scripts/FSM/EnemyState.gd"


# TODO: Animate dead
# Wait a time
# Remove from scene


func enter():
	.enter()
	anim.stop()
	anim.connect("animation_finished", self, "_anim_finished")
	anim.play("Dead2")

func handle_update(delta):
	pass

func _anim_finished(name):
	actor.free()

