extends Node


var streams = []
var samples = {}

func _ready():
	var children = get_children()
	for child in children:
		if child is AudioStreamPlayer3D:
			streams.append(child)

func register_sample(name : String, src : String):
	if not (name in samples):
		samples[name] = {
			"src" : src,
			"audio": null
		}

func is_playing_sample(name : String):
	#var asp = AudioStreamPlayer3D.new()
	#asp.playing
	if name in samples:
		for stream in streams:
			if stream.stream == null:
				return false
			if stream.stream.resource_path == samples[name].src:
				return stream.playing

func play(name : String, force : bool = false):
	if name in samples:
		if not is_playing_sample(name):
			var stream = null
			if force:
				stream = _get_oldest_stream()
			else:
				stream = _get_idle_stream()
			if stream:
				if stream.stream == null or stream.stream.resource_path != samples[name].src:
					if samples[name].audio == null:
						samples[name].audio = load(samples[name].src)
					stream.stop()
					stream.stream = samples[name].audio
				stream.play()

func stop():
	for stream in streams:
		stream.stop()


func _get_oldest_stream():
	# Just returning first stream for now.
	if streams.size() > 0:
		return streams[0]
	return null

func _get_idle_stream():
	for stream in streams:
		if not stream.playing:
			return stream
	return null
