extends Control


signal intro_complete

onready var tween = $Tween
onready var timer = $Timer
onready var intro_text = $CCntr/Intro_Text
onready var audio = $AudioIntro

var ignoreInput = false


func _input(event):
	if ignoreInput:
		return
	print("ignoreInput: ", ignoreInput)
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("attack"):
		timer.stop()
		audio.stop()
		_on_intro_completed()


func _on_AudioIntro_finished():
	audio.stop()
	var modStart = intro_text.modulate
	var modEnd = Color(modStart.r, modStart.g, modStart.b, 0)
	tween.interpolate_property(intro_text, "modulate", modStart, modEnd, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_text_faded")
	tween.start()


func _on_text_faded():
	var modStart = modulate
	var modEnd = Color(modStart.r, modStart.g, modStart.b, 0)
	tween.disconnect("tween_all_completed", self, "_on_text_faded")
	tween.interpolate_property(self, "modulate", modStart, modEnd, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "_on_intro_completed")
	tween.start()


func _on_intro_completed():
	tween.disconnect("tween_all_completed", self, "_on_intro_completed")
	ignoreInput = true
	visible = false
	set_process_input(false)
	emit_signal("intro_complete")



func _on_Timer_timeout():
	if visible:
		audio.play()
