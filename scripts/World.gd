extends Spatial

onready var player = $Game/Player
onready var audio = $MusicPlayer

func _ready():
	player.pause()
	get_tree().paused = true

func start_game():
	get_tree().paused = false
	player.pause(false)
	get_tree().set_input_as_handled()
	audio.stop()
	audio.stream = load("res://assets/audio/music/ancient_robot.ogg")
	audio.play()


func _on_TitleScreen_start():
	start_game()
