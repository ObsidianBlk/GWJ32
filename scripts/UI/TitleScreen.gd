extends Control

signal start

var ignoreEvents = true
var ignoreInput = false

func _ready():
	set_process_input(false)

func _input(event):
	if ignoreInput:
		return
	
	if ignoreEvents:
		ignoreEvents = false
		return
	
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		visible = false
		set_process_input(false)
		ignoreInput = true
		emit_signal("start")

func _on_intro_complete():
	set_process_input(true)
