extends Spatial

onready var player = $Game/Player

func _ready():
	player.pause()
	get_tree().paused = true

func start_game():
	get_tree().paused = false
	player.pause(false)
	get_tree().set_input_as_handled()


func _on_TitleScreen_start():
	start_game()
